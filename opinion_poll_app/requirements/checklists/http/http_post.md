# HTTP Post

> ## Sucesso
1. ✅ Request com verbo HTTP correto (POST)
2. ✅ Enviar o contet-type: application/json nos Headers
3. ✅ Request com body correto
4. ✅ Retorno de dados com código de status 200
5. ✅ Retorno nulo com código de status 200 sem dados
6. ✅ Retorno nulo com código de status 204 sem dados
7. ✅ Retorno nulo com código de status 204 com dados

> ## Erros
1. ✅ Bad Request - 400
2. ✅ Unauthorized - 401
3. ✅ Forbidden - 403
4. ✅ Not Found - 404
5. ✅ Internal Server Error - 500

> ## Exceção - Status code desconhecido ou diferente dos listados
1. ✅ Internal Server Error - 500

> ## Exceção - Exceção em Http Request
1. ✅ Internal Server Error - 500

> ## Exceção - Verbo Http inválido
1. ✅ Internal Server Error - 500