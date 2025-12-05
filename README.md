# Verificador de Versão

Exemplo de verificador de versão para apps Flutter.

## Descrição do Projeto

Este projeto verifica se o app precisa ser atualizado com base em um arquivo JSON presente no seu backend, ou um retorno JSON da sua API.

## Funcionalidades

- Verificação de versão
- Avisa sobre atualização obrigatória
- Avisa sobre atualização opcional
- Pode fornecer o link da loja para que o usuário faça a atualização

## Para rodar o exemplo:

Use um emulador de Android para os testes iniciais. O arquivo JSON de exemplo está no diretório `json_example`.

Rode um servidor web simples dentro do diretório `json_example`. Pode usar o Python para isso:

```bash
cd json_example
python -m http.server 8000
```

Depois de rodar o servidor, rode o app e abra no emulador.

## Contribuição

Contribuições são bem-vindas! Para contribuir, faça um fork do repositório e envie um pull request.

## Licença

MIT License

## Autor

[Pedro Conrad Jr](https://github.com/pconradjunior)

## Pacotes utilizados

- [Package Info Plus](https://pub.dev/packages/package_info_plus)
- [Version](https://pub.dev/packages/version)
- [HTTP](https://pub.dev/packages/http)

## Agradecimentos

- [Academia do Flutter](https://academiadoflutter.com.br/)-
- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)

## Mais informações

Veja mais no meu portfólio: [Pedro Conrad Jr](https://pconradjunior.github.io/)