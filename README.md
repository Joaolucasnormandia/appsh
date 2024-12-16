
<div align="center">

# Happy Saúde

<img src="assets/tbt.png" alt="Happy Saúde" width="400">

![Firebase](https://img.shields.io/badge/firebase-a08021?style=for-the-badge&logo=firebase&logoColor=ffcd34)
![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)

**"Cuidando da sua saúde e bem-estar, um dia de cada vez."**

</div>

---

## 📝 Sobre o Projeto

O **Happy Saúde** é um aplicativo focado no registro e acompanhamento do bem-estar físico e mental. Ele permite que os usuários:
- Façam **anotações diárias** de saúde e bem-estar.
- Acompanhem métricas importantes para manter uma vida equilibrada.
- Contem com uma **interface amigável** e intuitiva para facilitar o uso diário.

---

## ✅ Pré-requisitos

Antes de iniciar, você precisará:

- **Flutter SDK** (versão mínima recomendada: 3.24.4)  
👉 [Guia de instalação do Flutter](https://flutter.dev/docs/get-started/install)  
- **Dart SDK** (já incluso no Flutter).  
- **Firebase CLI** (para integração com o Firebase)  
  👉 [Guia de instalação do Firebase CLI](https://firebase.google.com/docs/cli).  
- **Editor de código** (ex: [VS Code](https://code.visualstudio.com/) ou Android Studio).  
- **Conta no Firebase** com um projeto configurado (Authentication e Firestore).  
  👉 [Documentação Firebase para Flutter](https://firebase.google.com/docs/flutter/setup).  
- Um dispositivo físico ou emulador configurado para testes.

---

## 🚀 Como Configurar o Projeto

1. **Clone o repositório para sua máquina:**
   ```bash
   git clone https://github.com/Joaolucasnormandia/appsh.git
   ```
   Entre no diretório do projeto:
   ```bash
   cd apps
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase:**
   - Acesse o [console do Firebase](https://console.firebase.google.com/).
   - Crie um projeto e adicione seu aplicativo Flutter.
   - Baixe o arquivo `google-services.json` (para Android) ou `GoogleService-Info.plist` (para iOS).
   - Coloque esses arquivos nas pastas correspondentes no projeto:
     - `android/app/` para `google-services.json`.
     - `ios/Runner/` para `GoogleService-Info.plist`.

4. **Conecte um dispositivo ou inicie um emulador.**

5. **Execute o aplicativo:**
   ```bash
   flutter run
   ```

---

## 📂 Estrutura do Projeto

```plaintext
appsh/
├── assets/           # Imagens, ícones e outros recursos estáticos.
├── lib/              # Código principal do aplicativo.
└── README.md         # Documentação do projeto.
```

---


## 💡 Funcionalidades Principais

1. **Registro diário:** Faça anotações diárias sobre saúde e bem-estar.  
2. **Monitoramento de métricas:**  
   - **Painel de Registro de Água:** Acompanhe sua hidratação diária.  
   - **Controle de Calorias:** Registre e visualize o consumo de calorias ao longo do dia.  
3. **Registro de Humor:** Acompanhe suas emoções diárias e visualize tendências ao longo do tempo.  
4. **Interface amigável:** Design intuitivo para facilitar o uso diário.  

---



## 🤝 Contribuição

Adoramos contribuições! Para contribuir com o projeto, siga os passos abaixo:

1. **Faça um fork do repositório.**
2. Crie uma branch para sua funcionalidade:
   ```bash
   git checkout -b minha-nova-funcionalidade
   ```
3. **Implemente sua funcionalidade** e faça commits:
   ```bash
   git commit -m "Adicionando minha nova funcionalidade"
   ```
4. Envie seu código para o repositório:
   ```bash
   git push origin minha-nova-funcionalidade
   ```
5. Abra um **Pull Request** detalhando as mudanças.

---

## 👥 Autores

<table align="center">
  <tr>
    <td align="center"><a href=https://github.com/Joaolucasnormandia><img src="https://avatars.githubusercontent.com/u/187022110?v=4" width="100px;" alt="João Lucas"/><br /><sub><b>João Lucas</b></sub></a></td>
    <td align="center"><a href=https://github.com/45-Renato><img src="https://avatars.githubusercontent.com/u/183830048?v=4" width="100px;" alt="Renato Almeida"/><br /><sub><b>Renato Almeida</b></sub></a></td>
    <td align="center"><a href=https://github.com/noedius><img src="https://avatars.githubusercontent.com/u/188925077?v=4" width="100px;" alt="Catriel Farias"/><br /><sub><b>Catriel Farias</b></sub></a></td>
    <td align="center"><a href="https://github.com/Ericsoubud"><img src="https://avatars.githubusercontent.com/u/171929327?v=4" width="100px;" alt="Eric Souza"/><br /><sub><b>Eric Souza</b></sub></a></td>
    <td align="center"><a href="https://github.com/israelazvd"><img src="https://avatars.githubusercontent.com/u/187023315?v=4" width="100px;" alt="Israel Azevedo"/><br /><sub><b>Israel Azevedo</b></sub></a></td>
  </tr>
</table>

---

## 📃 Licença

Este projeto está licenciado sob a [Licença MIT](./LICENCA).

---



