Feature: Login
- Para que seja possível visualizar e responder enquetes,
o usuário deverá acessar a própria conta e manter-se conectado.

Cenário: Credenciais Válidas
- Na solicitação de login, caso as credenciais informadas forem válidas,
o sistema deverá autenticar e redirecionar o usuário para a sua própria conta e manté-lo conectado.

Cenário: Credenciais Inválidas
- Na solicitação de login, caso as credenciais informadas forem inválidas,
o sistema deverá retornar uma mensagem informativa sobre credenciais incorretas.