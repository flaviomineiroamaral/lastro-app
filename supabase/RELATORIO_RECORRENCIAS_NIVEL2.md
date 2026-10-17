# Relatório de Comportamento: Lastro & Supabase (Gestão de Recorrências — Nível 2 Padrão Ouro)

Este documento descreve de ponta a ponta **como o banco de dados Supabase interage com o usuário no aplicativo Lastro** em todas as operações de **Contas a Pagar e Contas a Receber** (Lançamentos Únicos, Parcelados e Fixos).

---

## 1. Visão Geral da Arquitetura

Com a implementação do **Nível 2 (Padrão Ouro)**, toda a inteligência de criação, projeção de meses futuros, reajuste de valores e cancelamento de recorrências passou do celular do usuário para **dentro do motor transacional do Supabase**.

- **Arquivo da Migração**: `supabase/migrations/20261016220000_nivel2_recorrencia_padrao_ouro.sql`
- **Custom Actions no App**:
  - `gerarLancamentosRecorrentes` (`lib/lastro/a_receber_a_pagar/action/gerar_lancamentos_recorrentes.dart`)
  - `atualizarAgendamentoRecorrente` (`lib/lastro/a_receber_a_pagar/action/atualizar_agendamento_recorrente.dart`)
  - `excluirAgendamentoRecorrente` (`lib/lastro/a_receber_a_pagar/action/excluir_agendamento_recorrente.dart`)

---

## 2. Como o Sistema Age na CRIAÇÃO de Lançamentos

Quando o usuário preenche o formulário de **Novo Agendamento** e clica em **Salvar**, o Supabase identifica automaticamente um dos **3 perfis de lançamento**:

| Escolha do Usuário na Tela | Classificação no Banco (`tipo_recorrencia`) | O que o Supabase faz nos bastidores |
| :--- | :---: | :--- |
| **Recorrente desligado** | `'UNICO'` | Cria **1 registro** em `transacoes` com `total_parcelas = 1` e `parcela_atual = 1`. |
| **Recorrente ligado -> Botão "Parcelado"** (ex: 10x) | `'PARCELADO'` | Gera um código `grupo_recorrencia_id` e cria **exatamente as N parcelas** em `transacoes` (`1/10`, `2/10`... `10/10`), pois um parcelamento tem data certa para acabar. |
| **Recorrente ligado -> Botão "Fixo"** (ex: Aluguel, Internet, Mensalidade) | `'FIXO'` | 1. Registra o **Contrato-Mãe** na tabela `obrigacoes_recorrentes` (`ativo = true`, `janela_meses = 24`).<br>2. Gera imediatamente em `transacoes` os lançamentos dos próximos **24 meses** vinculados a esse contrato (`recorrencia_id`). |

### Regras Inteligentes na Criação:
1. **Proteção de Calendário (Dia 31 / Ano Bissexto)**:
   - Se o usuário cria uma conta fixa com vencimento todo **dia 31**, o Supabase ajusta automaticamente fevereiro para **28 (ou 29)** e abril/junho/setembro/novembro para **30**, voltando para **31** nos meses que têm 31 dias.
2. **Cálculo Automático da Competência (DRE)**:
   - Respeita a regra escolhida pelo usuário (*"Mesmo Mês do Vencimento"*, *"Mês Anterior ao Vencimento"*, *"Mês Seguinte ao Vencimento"* ou *"Manter Competência Fixa"*).
3. **1ª Parcela Já Paga/Recebida**:
   - Se o usuário cadastrar uma recorrência marcando a chave **"Pago / Recebido"** como ativa e selecionando a Conta Bancária, o Supabase grava a **1ª ocorrência** como `CONCILIADO` (já impactando o saldo bancário e o DFC) e cria todas as ocorrências dos meses seguintes como `PENDENTE` (sem conta bancária definida, aguardando a baixa futura).

---

## 3. Como Age o "Robô da Madrugada" (`pg_cron` — Janela Deslizante)

Para os lançamentos **FIXOS**, o usuário não precisa mais se preocupar com o "fim dos 60 meses" nem recadastrar contas fixas.

- **Quando roda**: Todos os dias às **03:00 da manhã** (job `lastro-gerador-recorrencias-diario` no `pg_cron` do Supabase).
- **O que ele faz**:
  1. Olha todos os contratos em `obrigacoes_recorrentes` que estão com `ativo = true`.
  2. Verifica até qual mês futuro já existem lançamentos gerados em `transacoes`.
  3. À medida que o tempo avança, ele **completa automaticamente o horizonte de 24 meses para frente**.
- **Trava Anti-Duplicidade**:
  - Existe um índice único no banco (`idx_transacoes_recorrencia_vencimento_unico`). Mesmo que o gerador seja acionado várias vezes seguidas, o Supabase **jamais duplica** um mês que já foi gerado.

---

## 4. Como o Sistema Age na EDIÇÃO (`Salvar` em um Agendamento)

Quando o usuário abre um lançamento existente na tela **Detalhe da Previsão** e clica em **Salvar**, o comportamento se adapta ao que o usuário está fazendo:

### Caso A: O usuário está apenas dando baixa (marcando como "Pago / Recebido")
- **O que acontece na tela**: O aplicativo **não exibe pergunta extra**.
- **O que o Supabase faz**: Liquida (`status = 'CONCILIADO'`) **apenas o mês aberto**, vinculando a Conta Bancária, a Data de Pagamento e o Comprovante àquele mês específico. Os próximos meses continuam `PENDENTE`.

### Caso B: O usuário está editando uma previsão pendente (mudou Valor, Descrição, Categoria, Centro de Custo ou Dia de Vencimento)
Se o lançamento for **Recorrente (`FIXO` ou `PARCELADO`)**, o aplicativo abre uma caixa de diálogo perguntando:

> **"Lançamento Recorrente"**
> *Deseja aplicar estas alterações apenas a este lançamento ou também aos próximos pendentes?*
> `[ Cancelar ]`  `[ Apenas este ]`  `[ Este e os próximos ]`

| Opção escolhida pelo Usuário | O que o Supabase faz (`fn_atualizar_agendamento_recorrente`) | Exemplo Prático |
| :--- | :--- | :--- |
| **Apenas este** | Atualiza **somente a transação daquele mês**. Os meses seguintes e o contrato original permanecem inalterados. | Naquele mês específico houve um desconto ou multa pontual no aluguel, mas nos meses seguintes o valor normal continua. |
| **Este e os próximos** | 1. Atualiza a transação atual **e todas as próximas que ainda estão `PENDENTE`** (mantendo o mês/ano de cada uma, mas ajustando o novo valor, descrição, categoria e o novo dia de vencimento).<br>2. **Preserva o passado**: meses anteriores ou que já foram pagos (`CONCILIADO`) **não são alterados**.<br>3. Atualiza o contrato em `obrigacoes_recorrentes` para que as futuras projeções automáticas já nasçam com os novos dados. | O aluguel sofreu reajuste anual de R$ 1.000 para R$ 1.150 a partir deste mês. Com 1 clique, todos os meses futuros já ficam com R$ 1.150, sem estragar o histórico dos meses que já passaram. |

---

## 5. Como o Sistema Age na EXCLUSÃO (Botão Lixeira)

Quando o usuário clica no botão **Excluir** na tela **Detalhe da Previsão**:

### Se for um Lançamento Único (`'UNICO'`):
- Exclui apenas aquele registro.

### Se for um Lançamento Recorrente (`'FIXO'` ou `'PARCELADO'`):
O aplicativo exibe a pergunta:

> **"Excluir Lançamento Recorrente"**
> *Deseja excluir apenas este lançamento ou encerrar este e todos os próximos pendentes?*
> `[ Cancelar ]`  `[ Apenas este ]`  `[ Este e os próximos ]`

| Opção escolhida pelo Usuário | O que o Supabase faz (`fn_excluir_agendamento_recorrente`) | Exemplo Prático |
| :--- | :--- | :--- |
| **Apenas este** | Apaga **somente o lançamento daquele mês**. Os meses seguintes continuam agendados normalmente. | O fornecedor concedeu 1 mês de isenção, mas a cobrança continua nos meses seguintes. |
| **Este e os próximos** | 1. Apaga o lançamento atual e **todos os lançamentos futuros `PENDENTE`** daquela recorrência.<br>2. **Preserva todo o histórico**: nenhum lançamento passado ou que já foi `CONCILIADO` (pago) é apagado, garantindo a integridade do caixa e da contabilidade.<br>3. Se for `FIXO`, marca o contrato em `obrigacoes_recorrentes` como **encerrado (`ativo = false` e `data_fim` preenchida)**, impedindo que o robô da madrugada volte a gerar essa conta. | A empresa cancelou uma assinatura de software a partir de outubro: tudo de outubro em diante some da previsão, mas os pagamentos feitos de janeiro a setembro continuam salvos no extrato, DRE e DFC. |
