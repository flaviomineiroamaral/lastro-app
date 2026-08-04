# 🛡️ Lastro Sigma Sistemas — Documentação e Memória do Projeto

Este documento serve como a **Memória do Projeto** no Antigravity, contendo o estudo detalhado da arquitetura, modelo de dados, infraestrutura Supabase, módulos de negócio e ações customizadas do sistema **Lastro Sigma Sistemas**.

---

## 📌 1. Visão Geral do Projeto

* **Nome do App:** Lastro Sigma Sistemas
* **Tipo:** Sistema de Gestão Financeira Corporativa Multi-Organização
* **Tecnologias Principais:**
  * **Framework:** Flutter / Dart (Web, Mobile & Desktop)
  * **Backend / BaaS:** Supabase (PostgreSQL 17, Auth & Storage)
  * **Gerenciador de Estado:** Provider (`FFAppState`)
  * **Roteamento:** GoRouter
  * **Relatórios & Exportações:** `pdf`, `printing`, `csvlib`

---

## ⚡ 2. Infraestrutura e Migrações Supabase (`supabase/`)

A pasta [`supabase/`](file:///c:/SIGMA/lastro-app/supabase) contém toda a infraestrutura de desenvolvimento local e scripts de migração do banco de dados:

* **Configurações do CLI (`config.toml`):**
  * Projeto: `lastro-app`
  * Versão PostgreSQL: **17**
  * Schemas expostos na API: `public`, `graphql_public`
  * Schema de auditoria estendida: `monitor`
* **Migração SQL Inicial (`supabase/migrations/20260721121500_schema_inicial.sql`):**
  * Arquivo contendo a estrutura completa (240 KB / 4.800+ linhas de DDL).
  * **Schema `monitor`**: Auditoria completa de operações DML (`monitor.audit_log`, `monitor.log_table_dml`, `monitor.purge_audit_log`, `monitor.objects_without_dml_since`).
  * **Regras de Integridade Financeira (Triggers & Functions)**:
    * `public.check_finance_usage()` — Impede exclusão de Plano de Contas ou Centro de Custo que já possuam transações vinculadas (exige desativação em vez de deleção física).
    * `public.check_permite_lancamento()` — Garante que apenas contas analíticas recebam lançamentos diretos (contas sintéticas são bloqueadas).
    * `public.add_organization_member()` — RPC de segurança para convite e associação de membros com validações de papéis (`funcao`).
    * `public.check_user_in_org()` — Função de verificação de permissão multi-tenant RLS.

---

## 🏛️ 3. Arquitetura do Banco de Dados

O backend é fundamentado em tabelas relacionais com suporte a views analíticas para alto desempenho financeiro.

### 📋 Tabelas Principais (`lib/backend/supabase/database/tables/`)

| Tabela | Descrição |
| :--- | :--- |
| `organizations` | Cadastro das empresas/organizações atendidas no sistema. |
| `organization_members` | Associação entre usuários (`profiles`) e organizações com papéis/permissões. |
| `membros` | Cadastro de membros de equipes nas organizações. |
| `profiles` | Perfil dos usuários do sistema. |
| `contas_bancarias` | Cadastro de contas correntes, caixas físicos e cartões de crédito. |
| `plano_contas` | Árvore hierárquica do plano de contas contábil/financeiro. |
| `centros_custo` | Centros de Resultado / Custos para alocação orçamentária. |
| `orcamentos_centro_custo` | Metas e orçamentos definidos por Centro de Custo. |
| `transacoes` | Lançamentos financeiros (Receitas, Despesas, Transferências, Agendamentos). |
| `obrigacoes_recorrentes` | Regras de lançamentos periódicos (contas a pagar/receber recorrentes). |
| `historico_saldos` | Registros históricos dos saldos das contas para análise temporal. |
| `resumo_dashboard` / `org_pulse` | Métricas pré-calculadas e indicadores de saúde operacional. |

### 📊 Views Analíticas e Relatórios SQL

* **DRE (Demonstrativo do Resultado do Exercício):**
  * `vw_dre_sintetico`, `vw_dre_analitico`, `vw_dre_detalhado`
* **DFC (Demonstrativo do Fluxo de Caixa) & Extratos:**
  * `vw_consolidado_lastro`, `vw_transacoes_competencia`, `vw_extrato_individual`, `vw_despesas_por_categoria`, `vw_receitas_por_categoria`
* **Centros de Custo (CR):**
  * `vw_resumo_centro_custo`, `vw_balancete_consolidado`
* **Consolidações e Cartões:**
  * `view_saldos_contas`, `vw_saldo_total_org`, `vw_faturas_cartao`, `vw_contas_para_notificar`, `vw_agendamentos`

---

## 📱 4. Módulos da Aplicação (`lib/lastro/`)

O aplicativo é estruturado modularmente por domínio financeiro:

```
lib/lastro/
├── autenticacao/       # Splash, Onboarding, Login, Gestão de Usuários e Seleção de Organização
├── dashboard/          # Visão executiva, gráficos DRE/DFC, alertas e saúde financeira
├── dre/                # Relatórios e análises sintéticas e analíticas de DRE
├── dfc/                # Relatórios e análises de Fluxo de Caixa (DFC)
├── cr/                 # Centros de Resultado (alocações, subsídios e balancete de CR)
├── cadastro/           # Plano de Contas, Contas Bancárias, Pessoas, Obrigações e Ajustes
├── a_receber_a_pagar/  # Previsão de títulos, liquidações e lançamentos recorrentes
├── cartao/             # Gestão de faturas de cartão de crédito e simulação de melhor compra
├── importacao/         # Parsing e conciliação de arquivos OFX, CSV e PDF
├── transacao/          # Extrato individual e detalhes por categoria
└── geral/              # Filtros de período, permissões de notificação e widgets globais
```

---

## ⚙️ 5. Ações e Regras de Negócio Customizadas (`lib/custom_code/actions/`)

As ações customizadas centralizam a inteligência financeira do sistema:

### 📥 Importação e Parsing
* `parseOfxFile` — Leitura e interpretação de arquivos bancários OFX.
* `processarCSV` — Parser de extratos bancários em formato CSV.
* `extrairTextoPDF` & `pdfParaBase64` — Processamento e envio de documentos PDF.

### 📐 Contabilidade & Plano de Contas
* `validarCodigoContabil` — Validação da máscara e sintaxe de códigos contábeis.
* `chamarRpcVerificarPai` — Verificação de relacionamento hierárquico pai-filho no plano de contas.
* `chamarRpcGerarProximoCodigo` — Geração sequencial dinâmica de subcontas contábeis.

### 📈 DRE, DFC & Centros de Resultado
* `getDreSintetico` / `getDreAnalitico` / `somarDetalhesDre` — Apuração contábil de receitas e despesas.
* `getDfcSintetico` / `getDfcAnalitico` / `somarDetalhesDfc` — Apuração de entradas e saídas de caixa.
* `getCrSintetico` / `getCrAnalitico` / `alocarSubsidio` / `estornarSubsidio` / `repassarArrecadacao` — Gestão orçamentária de Centros de Custo.

### 📄 Exportações de Relatórios (PDF e CSV)
* `gerarPdfDre`, `gerarPdfDfc`, `gerarPdfExtrato`, `gerarPdfBalanceteCR`, `gerarPdfDashboardGeral`.
* `gerarCSVPlanoDeConta`, `gerarCsvDfc`.

---

## 🧠 6. Memória Operacional do Desenvolvedor (Guia Antigravity)

Ao desenvolver ou modificar o código deste projeto, observe as seguintes diretrizes:

1. **Integridade de Lançamentos Contábeis:** Triggers no banco (`public.check_permite_lancamento`) rejeitam lançamentos em contas sintéticas. Certifique-se de que a interface do usuário ofereça apenas contas analíticas (`permite_lancamento = true`).
2. **Deleção Logica vs Física:** O banco impede a exclusão física (`DELETE`) de contas ou centros de custo com movimentação (`public.check_finance_usage`). Use desativação/inativação na interface.
3. **Plano de Contas:** Alterações em contas contábeis devem sempre validar se o código do pai existe (`chamarRpcVerificarPai`) antes de inserir subcontas.
4. **Gerenciamento de Estado:** O estado global é mantido em `FFAppState` ([`lib/app_state.dart`](file:///c:/SIGMA/lastro-app/lastro_sigma_sistemas/lib/app_state.dart)). Sempre sincronize o estado local com o Provider ao realizar mutações.
5. **Views do Supabase:** Telas de consulta analítica (DRE, DFC, Extrato) utilizam as Views SQL em vez de consultar a tabela `transacoes` diretamente para garantir melhor performance.
6. **Internacionalização e Formatação:** O app utiliza o idioma `pt-BR` nativamente para formatação de moeda e datas (`intl`).
