# Problemas conhecidos e roteiro de validação

[← README](../README.md)

## Escopo desta revisão

A documentação foi preparada por leitura dos cinco arquivos `.ijm` fornecidos. Nenhuma macro foi alterada ou executada no Fiji, e nenhuma imagem foi usada para avaliar os resultados. As observações são constatações do código ou riscos diretamente decorrentes dele. Os testes abaixo ainda precisam ser realizados.

## Prioridades antes de considerar as macros validadas

| Prioridade | Macro | Ação recomendada |
| --- | --- | --- |
| Bloqueante | FindFocusMacroEdge | Corrigir estrutura/sintaxe, caminho de entrada, laços, armazenamento do índice do máximo e índices Z inválidos |
| Alta | czitotiff, svstotiff, splittime | Colocar todo o processamento de cada arquivo dentro da condição de extensão; ignorar diretórios e tratar extensão sem diferenciar maiúsculas |
| Alta | svstotiff | Evitar a importação repetida da mesma série e validar o número solicitado |
| Alta | splittime | Implementar separação e salvamento por tempo, ou renomear a macro para refletir apenas a importação |
| Alta | FindFocusMacroEdge | Tratar média zero, crop inválido, offset, dimensões e calibração espacial |
| Média | czitotiff | Tratar metadado ausente e criar nomes únicos por série |
| Média | Todas que salvam | Definir comportamento para arquivos existentes e falhas de gravação |
| Média | Conversores e foco | Fechar apenas as imagens pertencentes ao processamento e controlar o uso de memória |

Essas ações são sugestões para uma etapa de manutenção posterior; não foram aplicadas aos códigos incluídos.

## Conjunto mínimo de testes

| Macro | Entrada controlada | Verificação |
| --- | --- | --- |
| czitotiff | CZI com pelo menos duas séries identificáveis | Um TIFF distinto por série, conteúdo e dimensões correspondentes |
| svstotiff | SVS com série conhecida | Uma exportação por arquivo da série selecionada, representação RGB e dimensões esperadas |
| saveallopenimages | Duas imagens com títulos diferentes | Dois TIFFs legíveis e fechamento das imagens ao terminar |
| splittime, após implementação | Hyperstack C=2, Z=3, T=4 | Quatro arquivos, cada um C=2, Z=3, T=1, se essa for a especificação adotada |
| FindFocusMacroEdge, após correção | Série Z=3, T=2 com planos de máximo conhecidos | Plano correto em cada tempo, pixels originais e propriedades coerentes |

## Casos adicionais

- Pasta vazia, pasta com subpastas e arquivos de extensões diferentes.
- Extensões em maiúsculas, espaços e caracteres acentuados nos caminhos.
- Destino já contendo um nome igual ao resultado previsto.
- Metadados de cena ausentes ou repetidos no CZI.
- Série inexistente no SVS.
- Imagens grandes, para avaliar consumo de memória e tempo.
- Na macro de foco: médias zero, recorte inválido, offset fora do intervalo e quantidade de imagens incompatível com Z×T.

Use uma pasta de saída nova para os testes básicos; avalie colisões em um teste separado com arquivos descartáveis.

## Registro sugerido por teste

```text
Data:
Responsável:
Macro e commit:
Sistema operacional:
Versões do Fiji / ImageJ / Bio-Formats:
Arquivo de entrada e dimensões C/Z/T:
Parâmetros:
Resultado esperado:
Resultado observado:
Comparação dos pixels / calibração:
Mensagens ou erros no Log:
Aprovado ou reprovado:
```

Não registre um teste como aprovado apenas porque a macro terminou ou exibiu `Finished!`. Reabra os arquivos e confira conteúdo, dimensões, nomes e metadados relevantes.

## Preparação do repositório

- Manter o README e os guias junto aos códigos correspondentes.
- Atualizar a documentação quando o comportamento das macros mudar.
- Registrar versões ou commits usados nas análises.
- Confirmar autoria dos arquivos sem cabeçalho e escolher uma licença, caso seja desejada a concessão de direitos de uso e redistribuição.
- Acrescentar imagens de exemplo somente quando houver autorização para compartilhá-las.
