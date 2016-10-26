# Comandos para testar o experimento
# Em qualquer um dos nodes (n1 até n5)

# Retornar registros do DNS do consul
dig @127.0.0.1 -p 8600 web.service.consul

# Retornar registros da API do consul
curl localhost:8500/v1/catalog/nodes

# Lista membros no command-line
consul members


# Comandos para executar em qualquer um dos pcs (pc2 até pc5)

# Testar o serviço web (cada curl deve retornar uma pagina diferente, mostrando qual node foi selecionado pelo load balancer)
curl 10.0.1.10

# Loop para testar multiplos requests
for i in {1..1000}; do curl 10.0.1.10; sleep 1; done
