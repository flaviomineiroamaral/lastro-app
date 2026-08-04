# 📘 Manual de Operações Diárias — Lastro App

Este documento é a **fonte central** de toda a arquitetura operacional e DevOps do Lastro App. Ele detalha todas as ferramentas, scripts, automações e processos necessários para o desenvolvimento diário, testes e publicação do aplicativo.

---

## 📂 Estrutura de Ferramentas e Atalhos

Todos os atalhos essenciais estão localizados na pasta da sua Área de Trabalho:
`Área de Trabalho > Lastro App - Ferramentas`

### Scripts Principais de Automação Diária
| Script / Atalho | O que faz | Quando usar |
| :--- | :--- | :--- |
| **`start_dev.ps1`** (Atalho: 1) | Roda `git pull` e inicia o Supabase local. | De manhã ou se reiniciar o computador (já roda automático no boot). |
| **`patch_android.ps1`** (Atalho: 2) | Re-aplica Gradle 8.14.0 e Kotlin 2.2.20 no código extraído. | **Toda vez** que extrair código novo do FlutterFlow, se baixar manualmente. |
| **`finish_day.ps1`** (Atalho: 3) | Faz `git add`, `git commit`, `git push` (ativa CI/CD Staging) e para o Supabase. | No final do expediente ou ao concluir uma funcionalidade. |
| **`open_studio.ps1`** (Atalho: 4) | Abre `http://127.0.0.1:54323` no navegador. | Para gerenciar o banco de dados visualmente (local). |
| **`open_folder.ps1`** (Atalho: 5) | Abre a pasta raiz do projeto no Explorer. | Para acesso direto aos arquivos. |

### 🚀 Novas Automações de Nível Avançado (Elite DevOps)
| Script / Hook | O que faz | Benefício |
| :--- | :--- | :--- |
| **`sync_flutterflow.ps1`** | Usa o FlutterFlow CLI para baixar, extrair o código e já rodar o `patch_android.ps1` automaticamente. | 1 comando substitui o download manual do site. *(Requer API Token configurado no script)* |
| **`create_migration.ps1`** | Pergunta o nome da migração, roda o `db diff` no Supabase e já abre o `.sql` gerado no VS Code para revisão. | Remove a necessidade de digitar comandos longos no terminal. |
| **`run_mobile.ps1`** | Checa dispositivos ADB, roda `flutter clean`, `pub get` e abre a compilação diretamente no celular Samsung. | Otimiza o fluxo de deploy local para testes físicos. |
| **Git Pre-Commit Hook** | Analisa o código do Flutter antes de todo commit. | Impede que você envie código quebrado para o repositório, garantindo a integridade do CI/CD. |

---

## ⚡ 1. Inicialização Matinal (Automática)

Ao ligar o Windows e fazer login, um atalho na pasta *Startup* do Windows abrirá uma janela do PowerShell e orquestrará a inicialização (`auto_start_lastro.ps1`). Ele aguarda o Docker Desktop iniciar e em seguida executa o `start_dev.ps1`, baixando atualizações e subindo o Supabase Local. 

*(Se precisar abrir manualmente: duplo clique em **`1 - Iniciar Ambiente`**).*

---

## 🗄️ 2. Alteração de Banco de Dados (Supabase DDL)

1. Crie tabelas e colunas visualmente no **Supabase Studio Local** (Atalho **`4`**).
2. Para gerar a migração em vez de rodar os comandos complexos, agora você usa o assistente:
   - Execute o script **`create_migration.ps1`**.
   - Digite o nome da alteração (ex: `cria_tabela_conciliacao`).
   - O arquivo será criado, salvo em `supabase/migrations/` e aberto para revisão.

---

## 🎨 3. Desenvolvimento no FlutterFlow & Patch Android

### Fluxo Automático (Recomendado)
Se você configurou sua Token do FlutterFlow, basta executar o **`sync_flutterflow.ps1`**. Ele vai buscar as alterações do FlutterFlow, descompactar os arquivos, e rodar as correções de versão do Android em uma tacada só.

### Fluxo Manual (Alternativa)
1. No FlutterFlow (Environment `Staging`), após as mudanças visuais ou clicar em *Get Schema*, vá em **Download Code**.
2. Extraia o ZIP em `C:\SIGMA\lastro-app\lastro_sigma_sistemas` (sobrescrevendo).
3. **Execute o atalho `2 - Aplicar Patch Android`** para corrigir as versões do Gradle (8.14.0) e Kotlin (2.2.20).

---

## 📱 4. Testes no Celular Físico (Samsung via USB)

1. Conecte seu smartphone Samsung ao computador (certifique-se de que a Depuração USB está ativa).
2. Execute o novo assistente **`run_mobile.ps1`**.
3. Ele limpará o cache, fará o `pub get` e lançará o App diretamente no seu celular para testes.

---

## 🛡️ 5. Encerrar o Expediente & CI/CD de Homologação (Staging)

1. Execute o atalho **`3 - Encerrar Expediente`**.
2. O novo **Pre-Commit Hook** do Git irá rodar o `flutter analyze` para checar erros lógicos no código Flutter. Se algo estiver quebrado, o commit será interrompido para você consertar.
3. Se estiver tudo OK, o script adicionará as mudanças e enviará ao GitHub.
4. O GitHub Actions (`supabase_deploy.yml`) executará as migrações automáticas no banco **Staging**, e o Supabase local será desligado.

---

## 🏁 6. Lançamento em Produção (Build & Deploy Controlados)

Quando a versão de Staging estiver testada, chegou a hora do Lançamento Oficial:

1. Vá ao seu repositório no GitHub.
2. Clique em **Releases** > **Draft a new release**.
3. Escolha uma Tag de versão (ex: `v1.0.0`) e publique.

### O que acontece na nuvem?
- **Banco de Dados:** O workflow `supabase_deploy.yml` fará o push das migrações diretamente para o ambiente financeiro de **Produção** (`lastro-financa`).
- **Aplicativo Android (NOVO!):** O workflow `android_build.yml` será acionado. Ele configurará o ambiente Flutter na nuvem, compilará o aplicativo (gerando o APK de Produção criptografado com suas chaves finais), e deixará o **.apk** anexado à página de Release no GitHub para download e publicação na loja. 
