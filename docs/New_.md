# New_ — rascunho de projeção e merge de dois canais LIF

[← README](../README.md) · [Código](../New_.ijm)

## Finalidade pretendida

Percorrer arquivos `.lif`, importar suas séries, separar C1/C2, fazer projeção máxima em Z e salvar um TIFF com os dois canais combinados. Diferentemente da variante com opções, este arquivo foi escrito para dois canais e não pergunta se deve projetar ou fazer merge.

## Entradas e saída prevista

Pede pastas de entrada e saída e depende de Bio-Formats Importer e Macro Extensions. Considera apenas `.lif` em minúsculas no primeiro nível da pasta.

Nome de saída pretendido:

```text
<base>_series<s>_<nome da série>_MERGE.tif
```

Não existe etapa para salvar separadamente os canais. O código executa Close All após cada série.

## O que o código tenta fazer

Consulta a quantidade de séries, importa como hyperstack, lê e limpa o nome de série, divide canais e percorre os títulos das janelas procurando C1/C2. Depois projeta cada canal quando há mais de um slice, combina as duas imagens e salva.

## Por que foi mantido como rascunho

Há problemas concretos que impedem tratar o fluxo como uma conversão pronta:

- Ao encontrar um título com prefixo C1/C2, chama `getImageID()` **sem selecionar a janela daquele título primeiro**. Assim, os IDs podem apontar para a imagem ativa, inclusive o mesmo ID para os dois canais.
- Se um canal não for encontrado, o ID permanece `-1`, mas o processamento continua sem validar sua existência.
- Quando há apenas um slice, a imagem é renomeada e seu próprio ID é atribuído à variável de projeção; a linha seguinte tenta fechar a imagem original. Se esse fechamento atingir o ID pretendido, também fecha o resultado que seria usado no merge.
- Usa `close(ch1ID)`, `close(ch2ID)` e `getTitle(proj1ID)`/`getTitle(proj2ID)`: essas formas de chamada precisam ser conferidas no interpretador. O padrão de selecionar a imagem antes de obter seu título não está seguido aqui.
- O Importer recebe índices iniciados em zero e não há `Ext.setSeries(s)` antes de ler o nome. Confira a correspondência entre série aberta e nome obtido.
- `nSlices` não é uma validação explícita das dimensões C/Z/T; não há lógica específica para séries temporais.

## Como consultar este arquivo

Use-o como registro da tentativa de automatizar projeção e merge de dois canais. Para entender uma implementação com escolhas e procura de canal por título antes de obter o ID, veja [LifToTiff_zproject_merge](LifToTiff_zproject_merge.md), que também possui pontos a conferir.
