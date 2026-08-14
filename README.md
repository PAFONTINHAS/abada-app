# SISTEMA ABADÁ APP
---
> Sistema integrado de gestão de turmas, eventos regionais, acervo histórico e controle administrativo (TUSCA) para a associação ABADÁ-CAPOEIRA. Desenvolvido como projeto de TCC na Universidade Federal do Paraná (UFPR)
---
## Central de Governança e Documentação Tecnica

Para garantir a qualidade, padronização e manutenibilidade do código por toda a equipe, utilize os guias rápidos abaixo antes de iniciar qualquer desenvolvimento:

| Documento | Descrição/Objetivo | Link Rápido |
|-|-|-|
|**Padrões de Código**| Gitflow, convenções de nomenclatura, limites de linha e Clean Code | <a href="CONTRIBUTING.md">Acessar Guia</a> |
|**Arquitetura do Sistema**| Padrões de projeto, gerenciamento de estado (Bloc/Provider) e pastas | `docs/ARCHITECTURE.md` (em breve) |
|**Modelagem de Dados**| Estrutura de coleções NoSQL, subcoleções e índices do Firebase | `docs/DATABASE.md` (em breve)|
|**Segurança e LGPD**| Política de expiração de comprovantes PIX e proteção de dados | `docs/SECURITY.md` (em breve)|

## Sobre o Projeto

O **ABADÁ APP** foi projetado para resolver a fragmentação de informações na gestão da capoeira, substituindo controles informais em planilhas por uma plataforma escalável.

  - ### Principais Módulos
    - **Gestão de Perfis de Acesso**: Trava de segurança baseada no batismo e aprovação de vínculo por instrutores responsáveis.
    - **Gestão de Turmas e Polos**: Mapeamento de unidades, horários e geração de métricas de impacto por região.
    - **Sistema TUSCA Integrado**: Automação de solicitações por isenção, pagamentos bianuais e emissão de Selo Digital de Regularidade.
    - **Gestão Regional e Nacional de Eventos**: Calendário e mapa interativo com sistema automático de datas por graduação
    - **Wiki-Abadá e Cancioneiro**: Acervo histórico e catálogo oficial de músicas com controle de direitos autorais  

## Como Executar o Projeto Localmente

  - ### Pré Requisitos
    - **Flutter SDK**: `>= 3.22.0`
    - **DART SDK**: `>= 3.4.0`
    - **GIT** configurado na sua máquina
    - **VSCode** (com as extensões **Flutter** e **Dart** instaladas) ou **Android Studio**
  
  - ### Passos para Instalação

    - #### **Clone o repositório**: 
     
    ```
      git clone https://github.com/PAFONTINHAS/abada-app.git
      cd abada-app
    ```
  
    - ### **Certifique-se de estar na branch correta para desenvolvimento**:
     
    ```
      git checkout development
    ```

    - ### **Instale as dependências do projeto**:
    ```
      flutter pub get
    ```

    - ### **Instale as dependências do projeto**:
    ```
      flutter run
    ```

## EQUIPE DE DESENVOLVIMENTO

- **Peterson Almeida Fontinhas** - *Software Engineer & Architect* 
- **Isabella Luiza Costa Vicente** - *Software Engineer* 
- **Clarissa Eri Morita** - *Software Engineer* 

 