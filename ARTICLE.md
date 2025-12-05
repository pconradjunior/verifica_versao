# Implementação de Verificação de Versão em Apps Flutter

## Introdução

No ciclo de vida de um aplicativo móvel, garantir que os usuários estejam utilizando a versão mais recente é crucial. Atualizações podem trazer novas funcionalidades, correções de bugs críticos ou melhorias de segurança. Além disso, em alguns casos, mudanças na API backend podem tornar versões antigas do app incompatíveis, exigindo uma atualização obrigatória (Force Update).

Este artigo detalha uma implementação técnica robusta e simples para verificação de versão em apps Flutter, permitindo gerenciar atualizações opcionais e obrigatórias remotamente através de um arquivo JSON.

## Visão Geral da Solução

A solução consiste em dois componentes principais:
1.  **Backend (Fonte da Verdade)**: Um arquivo JSON hospedado que contém a versão mais recente e a configuração de obrigatoriedade.
2.  **Frontend (App Flutter)**: Um serviço que consulta este JSON ao iniciar, compara com a versão instalada e exibe um diálogo apropriado ao usuário.

### Dependências

O projeto utiliza os seguintes pacotes essenciais:
*   `http`: Para realizar a requisição GET ao arquivo JSON remoto.
*   `package_info_plus`: Para obter a versão atual instalada no dispositivo do usuário.
*   `version`: Para facilitar a comparação semântica de versões (ex: comparar se "1.0.1" < "1.0.2").
*   `url_launcher`: Para abrir a loja de aplicativos (Google Play ou App Store) quando o usuário decidir atualizar.

## Detalhes da Implementação

### 1. O Contrato de Dados (JSON)

O backend deve fornecer um JSON com a seguinte estrutura. Isso permite controlar versões diferentes para Android e iOS, além de definir URLs de loja específicas.

```json
{
    "android_version": "2.1.0",
    "ios_version": "2.5.0",
    "mandatory": false,
    "android_store_url": "https://play.google.com/store/apps/details?id=com.example.app",
    "ios_store_url": "https://apps.apple.com/br/app/your-app-name/id1234567890"
}
```

A flag `mandatory` define se o usuário pode ou não ignorar o aviso de atualização.

### 2. Lógica de Verificação (`VersionChecker`)

A classe `VersionChecker` é responsável por orquestrar a verificação.

*   Ela obtém a versão instalada.
*   Faz o fetch do JSON remoto.
*   Detecta a plataforma (Android ou iOS) para ler a chave correta do JSON.
*   Compara as versões utilizando a sobrecarga de operadores da lib `version` (`installed < remoteVersion`).

```dart
// Exemplo simplificado da lógica de comparação
final bool needsUpdate = installed < remoteVersion;
final bool mandatory = data["mandatory"] == true;
```

Essa separação garante que o app iOS não peça atualização se apenas a versão Android mudou, e vice-versa.

### 3. Interface do Usuário (`VersionDemoApp`)

A camada de UI reage ao resultado da verificação. O ponto crucial aqui é o tratamento da UX para atualizações obrigatórias versus opcionais.

*   **Atualização Opcional**: O diálogo possui um botão "Ignorar" e pode ser fechado clicando fora dele. O usuário escolhe se quer atualizar agora.
*   **Atualização Obrigatória**: O diálogo remove a opção de fechar.
    *   `barrierDismissible: false`: Impede fechar clicando fora.
    *   `PopScope` (antigo `WillPopScope`): Intercepta o botão "Voltar" do Android, impedindo que o usuário saia do diálogo sem atualizar.

O código abaixo ilustra como o diálogo é configurado para impedir o fechamento em casos obrigatórios:

```dart
showDialog(
  context: context,
  barrierDismissible: !mandatory, // Bloqueia clique fora se obrigatório
  builder: (context) {
    return PopScope(
      canPop: false, // Bloqueia botão voltar do sistema
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (!mandatory) Navigator.of(context).pop(); // Só fecha se não for obrigatório
      },
      child: AlertDialog(
        // ... Conteúdo do diálogo
        actions: [
          if (!mandatory) // Botão Ignorar apenas se opcional
            TextButton(child: Text("Ignorar"), ...),
          TextButton(child: Text("Atualizar Agora"), ...),
        ],
      ),
    );
  },
);
```

## Conclusão

Esta implementação oferece um controle refinado sobre o ciclo de vida do aplicativo. Ao desacoplar a regra de obrigatoriedade do código do app (colocando-a no JSON remoto), os desenvolvedores ganham a flexibilidade de "promover" uma atualização de opcional para obrigatória a qualquer momento, sem precisar lançar uma nova versão do app apenas para isso. É uma estratégia essencial para manter a base de usuários unificada e segura.
