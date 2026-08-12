# Diretrizes de Engenharia e Padrões de Código

Este documento estabelece as políticas de versionamento, padrões de nomenclatura, arquitetura e qualidade de código que devem ser obrigatoriamente seguidos por **todos os membros da equipe** durante o desenvolvimento do aplicativo **ABADÁ APP**

## 1. Estrutura de Branches e Fluxo de Trabalho (Gitflow)

O controle de versão do projeto é gerenciado via Git e hospedado no GitHub, utilizando uma adaptação simplificada do Gitflow para garantir a estabilidade do código.

 - ### Proteção de Branches Principais
    - `main` **(Ambiente de Produção)**: Contém exclusivamente código estável, testado e validado. **Pushes diretos são bloqueados**.
    - `development` **(Ambiente de desenvolvimento)**: Centraliza o código de integração da sprint atual. **Pushes diretos são bloqueados**.

  - ### Fluxo de Desenvolvimento
    - Para cada nova funcionalidade, correção ou tarefa da sprint, o desenvolvedor deve criar uma branch a partir da `development` utilizando a convenção:
      - `feature/nome-da-feature`
      - `fix/nome-da-correção`
      - `refactor/nome-da-melhoria`
    - Ao finalizar a tarefa, o desenvolvedor deve abrir um **Pull Request (PR)** direcionado à branch `development`.
    - **Revisão de código (Code Review)**: Todo Pull Request exige obrigatoriamente a aprovação de pelo menos um membro da equipe antes de ser mergeado.
    - **Fechamento de Sprint**: Ao término de cada sprint quinzenal, caso todas as tarefas planejadas tenham sido concluídas e validadas na `development`, a equipe realizará a integração de `development`para `main`
    - A branch `development` é a única branch que tem a permissão de realizar o merge na branch `main`. 

## 2. Convenção de Nomenclatura e Idioma

- ### Idioma
  - **Código-fonte em inglês**: Toda a estrutura do código (nome de arquivos, classes, métodos, variáveis, comentários, commits) **deve ser escrita estritamente em inglês**.
  - **Exceção**: Textos, rascunhos de UI e strings exibidos na interface do aplicativo para o usuário final permanecem em Português.

- ### Padronização do Framework (Flutter/Dart) 

  Para manter a conformidade com as diretrizes oficiais da linguagem Dart e do ecossistema Flutter:

  |ELEMENTO| Convenção | Exemplo |
  |-|-|-|
  |**Arquivos e Pastas**| `snake_case` |  `user_profile_screen.dart`, `auth_service.dart` |
  |**Classes, Enums e Interfaces**| `PascalCase` | `EventRepository`, `StudentProfile` |
  |**Variáveis e Métodos**| `camelCase` | `getUserProfile()`, `isTuscaValid`|
  |**Constantes**|`camelCase`|`defaultPadding`, `apiBaseUrl`|


## 3. Qualidade de Código e Clean Code

- ### Expressividade e Semântica de Variáveis e Funções

  - **Proibição de Variáveis Curta ou Sem Sentido**: É **expressamente** proibido e vetado o uso de abreviações ambíguas ou nomes genéricos na declaração de variáveis e funções (ex: `txt`, `a`, `bool valid()`, `temp`, `aux`) 

  - Nomes de variáveis e funções devem descrever exatamente sua função e intenção no sistema
    - ❌ Incorreto:
      - `String txt = "txt"`;
      - `String getUsrNknm(String usr){}`
    - ✅ Correto: 
      - `String confirmationDialogTitle = "Cancel Event";`
      - `String getUserNickname(String userId){}`
  
- ### Modularização e Tamanho de arquivos
  - **Limite Extensivo**: Arquivos que ultrapassarem o limite de **150 linhas de código** devem ser obrigatoriamente refatorados e divididos em componentes menores
  - **Componentização da UI**: A extensão visual das telas (como decorators) não justificam arquivos acoplados. Widgets complexos ou trechos de decoração repetitivos devem ser extraídos para arquivos/widgets próprios na pasta `widgets/`
  - **Refatoração Contínua**: O **Clean Code** é um princípio ativo do projeto. Escrever código legível reduz a incidência de bugs e otimiza o tempo de leitura de toda a equipe 
  
  
<br>  

---
  > “Qualquer um pode escrever um código que o computador entenda. Bons programadores escrevem códigos que os humanos entendam.” — Martin Fowler 


<br>