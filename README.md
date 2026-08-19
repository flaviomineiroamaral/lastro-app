# 🛡️ Lastro Sigma Sistemas — Manual de Operações e Documentação do Projeto

Este documento é a **fonte central** de arquitetura, operações diárias e guia de desenvolvimento do **Lastro Sigma Sistemas**.

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
  * **Integração Android:** Intent Filter para recebimento de extratos de banco (`application/pdf`, `application/x-ofx`, `text/csv`)

---

## 💻 2. Ferramentas e Atalhos da Área de Trabalho

Todos os scripts utilitários estão organizados na pasta da sua Área de Trabalho:
`Área de Trabalho > Lastro App - Ferramentas`

| Atalho / Script | Comando / Arquivo Alvo | Descrição & Quando Usar |
| :--- | :--- | :--- |
| **`1 - Iniciar Ambiente`** | `scripts/start_dev.ps1` | Sincroniza o código com o GitHub (`git pull`) e inicia o Supabase local. Use no início do dia. |
| **`2 - Aplicar Patch Android`** | `scripts/patch_android.ps1` | Re-aplica as correções do Gradle 9.1.0, Kotlin 2.3.20 e o **Share Intent Filter** no `AndroidManifest.xml` após exportar do FlutterFlow. |
| **`3 - Encerrar Expediente`** | `scripts/finish_day.ps1` | Executa o commit e push para o GitHub (ativando a esteira CI/CD) e encerra os serviços do Supabase. |
| **`4 - Abrir Supabase Studio`** | `http://127.0.0.1:54323` | Abre a interface de gerenciamento do banco de dados local no seu navegador. |
| **`5 - Abrir Pasta do Projeto`** | `C:\SIGMA\lastro-app` | Abre a raiz do projeto no Windows Explorer. |
| **`7 - Assistente de Migração`** | `scripts/create_migration.ps1` | Pergunta o nome da migração, executa o `db diff` no Supabase e abre o SQL para revisão no VS Code. |
| **`8 - Lançar no Celular Físico`** | `scripts/run_mobile.ps1` | Limpa o cache, baixa pacotes e compila o app no seu smartphone Android (ADB/USB). |

---

## ⚡ 3. Fluxo de Integração FlutterFlow + GitHub

Como o FlutterFlow exporta o código diretamente para a raiz do repositório no GitHub:

1. **Alterações no FlutterFlow:** Desenvolva telas e componentes no editor do FlutterFlow e clique em **Push to GitHub**.
2. **Aplicação de Patch Nativo:** Após o push do FlutterFlow, execute no seu computador ou terminal:
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/patch_android.ps1
   ```
3. **Validação:** Isso garante que o `AndroidManifest.xml` continue reconhecendo os arquivos do app de banco compartilhados pelo celular.

---

## 🏛️ 4. Arquitetura do Banco de Dados Supabase (`supabase/`)

O backend é fundamentado em PostgreSQL 17 com suporte a views analíticas para alto desempenho financeiro.

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

* **DRE (Demonstrativo do Resultado do Exercício):** `vw_dre_sintetico`, `vw_dre_analitico`, `vw_dre_detalhado`
* **DFC (Demonstrativo do Fluxo de Caixa):** `vw_consolidado_lastro`, `vw_transacoes_competencia`, `vw_extrato_individual`
* **Centros de Custo (CR):** `vw_resumo_centro_custo`, `vw_balancete_consolidado`

---

## 📱 5. Estrutura dos Módulos da Aplicação (`lib/`)

```
lib/
├── autenticacao/       # Splash, Onboarding, Login, Gestão de Usuários e Seleção de Organização
├── dashboard/          # Visão executiva, gráficos DRE/DFC, alertas e saúde financeira
├── dre/                # Relatórios e análises sintéticas e analíticas de DRE
├── dfc/                # Relatórios e análises de Fluxo de Caixa (DFC)
├── cr/                 # Centros de Resultado (alocações, subsídios e balancete de CR)
├── cadastro/           # Plano de Contas, Contas Bancárias, Pessoas, Obrigações e Ajustes
├── a_receber_a_pagar/  # Previsão de títulos, liquidações e lançamentos recorrentes
├── cartao/             # Gestão de faturas de cartão de crédito
├── importacao/         # Parsing e conciliação de arquivos OFX, CSV e PDF (Recebidos via Share Intent)
└── transacao/          # Extrato individual e detalhes por categoria
```

---

## 🧠 6. Regras de Negócio Importantes

1. **Integridade de Lançamentos Contábeis:** Triggers no banco (`public.check_permite_lancamento`) rejeitam lançamentos em contas sintéticas. Somente contas analíticas (`permite_lancamento = true`) aceitam lançamentos.
2. **Deleção Lógica vs Física:** O banco impede exclusão física (`DELETE`) de contas ou centros de custo com movimentação (`public.check_finance_usage`). Utilize desativação/inativação na interface.
3. **Compartilhamento de Banco (Share Intent):** O `AndroidManifest.xml` registra o Intent Filter para `android.intent.action.SEND` capturar arquivos enviados de apps de bancos diretamente para o módulo de importação.
