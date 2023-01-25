# HTTP Post

> ## Sucesso
1. ✅ Request com verbo HTTP correto (POST)
2. ✅ Enviar o contet-type: application/json nos Headers
3. ✅ Request com body correto
4. ✅ Retorno de dados com código de status 200
5. ✅ Retorno nulo com código de status 200 sem dados
6. No content - 204 e resposta sem dados

> ## Erros
1. Bad Request - 400
2. Unauthorized - 401
3. Forbidden - 403
4. Not Found - 404
5. Internal Server Error - 500

> ## Exceção - Status code diferente dos citados acima
1. Internal Server Error - 500

> ## Exceção - Http request deu alguma exceção
1. Internal Server Error - 500

> ## Exceção - Verbo http inválido
1. Internal Server Error - 500