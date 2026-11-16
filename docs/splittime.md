# splittime.ijm

[← README](../README.md) · [Código](../splittime.ijm)

## Objetivo

O nome sugere separação de pontos temporais, e há uma linha comentada com a opção `split_timepoints`. Entretanto, **o código ativo apenas importa arquivos `.tif` como hyperstacks; não separa os tempos e não salva resultados**.

## Requisitos e entradas

- Fiji com Bio-Formats Importer e Bio-Formats Macro Extensions.
- Pasta contendo TIFFs com extensão `.tif` em minúsculas.
- Uma pasta de saída é solicitada, mas não é usada pelo código ativo.

A busca não é recursiva. `.tiff` e `.TIF` não são contempladas pela condição atual.

## Uso e comportamento observado no código

1. Execute a macro.
2. Escolha **Get input directory**.
3. Escolha **Get outputdirectory**, ciente de que nenhum arquivo é escrito nessa pasta.
4. A macro lista as entradas, imprime informações no Log e solicita importação via Bio-Formats com `autoscale`, `color_mode=Default`, `view=Hyperstack` e `stack_order=XYCZT`.

O código ativa modo batch e não contém uma chamada explícita para desativá-lo nem uma etapa de apresentação dos resultados. A visibilidade das imagens ao fim deve ser verificada no Fiji usado.

## Saídas

Não existem chamadas ativas de salvamento. A saída do processamento se limita à importação de imagens na sessão e mensagens no Log; não há TIFF por ponto temporal.

## Limitações identificadas

- O `if` sem chaves condiciona apenas a atribuição de `fileName`. A importação ocorre também para entradas incompatíveis, usando potencialmente uma variável indefinida ou o nome do arquivo anterior.
- `outputdir` é solicitado e nunca utilizado.
- A opção `split_timepoints` existe somente em uma linha comentada, portanto não produz efeito.
- Não existe laço de exportação por tempo nem convenção de nomes para esses resultados.
- Não há fechamento explícito das imagens após cada importação, validação de dimensões ou tratamento de erros.

## Próximas etapas sugeridas

Para implementar a finalidade indicada pelo nome: corrigir o filtro, definir se a saída de cada tempo deve preservar todos os canais e planos Z, ativar a separação apropriada, salvar cada resultado com índice temporal único e liberar as imagens após salvar. Essas alterações não foram feitas nesta entrega de documentação.

## Autoria

O arquivo fornecido não contém autoria ou data de atualização no cabeçalho.
