# Aplicativo de Rastreamento de Cargas para Motoristas
O aplicativo de rastreamento de carga é uma solução tecnológica desenvolvida para motoristas, com o objetivo de facilitar o acompanhamento das rotas e paradas durante as viagens de transporte de mercadorias. Através de uma integração direta com a API de um sistema gestor, o aplicativo permite que o motorista aceite viagens previamente designadas, compartilhe a sua localização em tempo real com o gestor da rota, e forneça informações cruciais sobre o progresso da viagem.

O foco do aplicativo é ser simples, intuitivo e eficiente, uma vez que será utilizado exclusivamente por motoristas. Além disso, a solução foi concebida de forma escalável, permitindo ao proprietário oferecer o serviço a diversas empresas que possuam operações logísticas.

## Funcionalidades
- **Login com CPF**: O motorista faz login apenas com o CPF que foi previamente cadastrado pelo gestor.
- **Aceite da LGPD**: Na primeira vez que o motorista acessa o aplicativo, ele deve aceitar os termos da LGPD. Se não aceitar, é redirecionado para a página de login.
- **Página de Viagem**: Após o aceite, se houver uma viagem vinculada ao motorista, ele verá um mapa com a rota da viagem, incluindo informações como origem, paradas, destino e a data prevista de chegada.
- **Aceitação da Viagem**: Ao aceitar a viagem, a localização do motorista passa a ser compartilhada com o gestor, com atualizações automáticas a cada 5 minutos.
- **Navegação Integrada**: O motorista pode navegar na rota diretamente no aplicativo, através da integração com a API do **Mapbox** ou ser redirecionado para o **Waze**.
- **Finalização da Viagem**: Após a conclusão da viagem, o motorista clica no botão de "Finalizar", interrompendo o compartilhamento de localização e notificando o gestor da entrega realizada.
- **Página de Conclusão de Viagem**: Após finalizar, o motorista é redirecionado para uma página de conclusão com opções de contato via **WhatsApp** com o gestor ou para atualizar o aplicativo.
- **Botão flutuante do WhatsApp**: Disponível em todas as telas (exceto na tela de login e de conclusão de viagem) para facilitar o contato com o gestor.
- **Integração com APIs**: O aplicativo é integrado com as APIs de navegação (Mapbox e possivelmente Waze) e com a API do sistema gestor, que designa as viagens e motoristas.

## Pré-requisitos

## Instalação

## Autores
