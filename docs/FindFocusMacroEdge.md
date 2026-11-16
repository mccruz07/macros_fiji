# FindFocusMacroEdge.ijm

[← README](../README.md) · [Código](../FindFocusMacroEdge.ijm)

## Objetivo e estado atual

A finalidade declarada é transformar uma sequência de imagens em um hyperstack Z×T, calcular uma medida de foco por plano Z e produzir uma série temporal com um plano selecionado por tempo. Há opções de filtro de bordas, região central de análise e deslocamento em Z.

**Estado:** o arquivo recebido apresenta problemas de sintaxe e lógica. A descrição abaixo explica sua intenção e implementação; não certifica funcionamento. Não use a saída como seleção focal validada antes de corrigir e testar a macro.

## Requisitos e entradas previstas

- Fiji / ImageJ com os comandos Image Sequence, Stack to Hyperstack, Duplicate e Find Edges.
- Pasta com uma sequência de imagens de dimensões compatíveis.
- Um canal por imagem: a conversão fixa `channels=1`.
- Quantidade de imagens compatível com `zplanes × tframes` e ordenação compatível com `XYCZT` (Z variando antes de T, para um canal).
- Pasta de saída existente e memória para a sequência completa; o filtro de bordas cria uma duplicata.

O código não verifica quantidade, ordenação, dimensões ou consistência da sequência antes da conversão. Não há versão de Fiji validada.

## Parâmetros

Após escolher entrada e saída, a macro exibe **Parameters Configuration**:

| Campo | Variável | Padrão no código | Finalidade |
| --- | --- | --- | --- |
| Apply a edge filter… | `edge` | Desmarcado | Duplicar a imagem e aplicar Find Edges para a medida de foco |
| Number of z planes | `zplanes` | `26` | Número de planos por tempo |
| Number of time-lapse frames | `tframes` | `8` | Número de tempos; o exemplo do texto menciona 400, mas o valor inicial é 8 |
| Time frame in seconds | `ttime` | `90` | Intervalo temporal gravado nas propriedades da saída |
| Method | `mmethod` | Primeira opção: `mean` | Centro da soma de desvios: média ou moda |
| Crop size in pixels | `cropsize` | Campo vazio | Lado do quadrado central; informe `0` explicitamente para não recortar |
| Z-plane Offset | `offset` | `0` | Deslocamento em relação ao plano selecionado |

`zplanes`, `tframes`, `ttime` e `cropsize` passam por `parseInt`; não existe validação adequada de valores vazios, negativos ou incompatíveis. Para o offset, a intenção é usar um número inteiro de planos, mas o código não o exige.

## Fluxo pretendido

1. Carregar a sequência e convertê-la em hyperstack com um canal, Z e T informados.
2. Se solicitado, duplicar a sequência e aplicar Find Edges. O recorte físico da duplicata ocorre apenas nesse ramo.
3. Calcular uma pontuação para cada plano de cada tempo, usando toda a imagem ou uma região central.
4. Escolher o plano de maior pontuação e aplicar o offset.
5. Copiar o plano correspondente da imagem original, sem filtro, para a imagem `Output`.
6. Configurar as propriedades temporais e salvar em TIFF.

Este fluxo depende das correções descritas abaixo. A macro também chama `close("\\Others")` em várias etapas, podendo fechar outras imagens abertas na sessão.

## Medida implementada

A expressão calculada é:

```text
pontuação = soma((pixel − centro)²) / (H × W × média)
```

- `centro = mean` no método `mean`.
- `centro = mode` no método `mode`.
- O denominador continua usando `mean` nos dois métodos.
- `H × W` representa a área percorrida no laço de pixels.

A opção `mode` é uma variante presente no código, não uma comprovação de equivalência ao método citado no cabeçalho. Sem filtro de bordas, a soma pode usar apenas a região central enquanto as estatísticas são obtidas antes, sem uma seleção central correspondente; assim, a média/moda pode representar a imagem inteira. Esse comportamento deve ser definido e corrigido conforme o método desejado.

## Saída prevista

Uma imagem chamada `Output`, formada por planos copiados da imagem original e salva por:

```text
saveAs("TIFF", outputdir + StackID)
```

`StackID` contém o título do hyperstack original. Não há sufixo explícito que identifique foco ou método.

As propriedades finais solicitam C=1, Z=1, T=`tframes`, intervalo `ttime` em segundos e `pixel_width`, `pixel_height` e `voxel_depth` iguais a `1.0000`. Portanto, **a calibração espacial original não é preservada por essa etapa**; não se deve inferir uma unidade física válida desses valores.

## Problemas identificados no arquivo recebido

1. **Estrutura incompleta:** o laço externo `for (i = 1; …)` abre uma chave sem fechamento correspondente até o fim do arquivo. A atribuição `list=getFileList(dir)` também não termina com ponto e vírgula. A sintaxe precisa ser revisada antes da execução.
2. **Entrada da sequência:** o comando usa a string literal `"open=dir"`, sem concatenar o caminho da variável `dir`. A seleção efetiva da pasta precisa ser corrigida e verificada.
3. **Laço externo inconsistente:** pretende avançar de `zplanes` em `zplanes`, mas não usa o índice para delimitar grupos na importação. A variável `i` também é reutilizada no laço de pixels, alterando o controle externo.
4. **Plano de máximo incorreto:** quando surge uma pontuação maior, o código executa `m++`, em vez de armazenar o índice `l`. Isso conta quantas vezes o máximo foi superado, não a posição do plano com maior pontuação. Por exemplo, pontuações `[5, 3, 9]` resultam em `m=2`, embora o máximo esteja no plano 3.
5. **Índices fora do intervalo:** `m` começa em zero e pode continuar zero. `m + offset` não é limitado ao intervalo `1…slices`. Após o laço de Z, o código ainda chama `Stack.setSlice(l)` quando `l` já pode valer `slices+1`.
6. **Divisão por zero:** não existe tratamento para média igual a zero ou pontuações não finitas.
7. **Recorte:** a verificação compara o tamanho apenas com a largura, sem validar a altura. Um quadrado pode ultrapassar a imagem. O campo inicialmente vazio também precisa de tratamento.
8. **Checkbox:** o valor booleano de `Dialog.getCheckbox()` passa por `parseInt` antes da comparação com `1`; esse caminho deve ser simplificado ou validado no interpretador utilizado.
9. **Colisão com `Output`:** se já houver uma janela com esse nome e ela sobreviver às etapas de fechamento, o código pode reutilizá-la e adicionar slices. A saída deveria ser identificada de forma inequívoca.
10. **Calibração e recursos:** o código substitui a escala espacial por 1, fecha outras imagens, não valida nomes de saída e não oferece recuperação de erros. O processamento pixel a pixel pode ser lento em imagens grandes.

## Uso após correção

Abra uma sessão com somente as imagens necessárias, escolha uma sequência pequena com ordenação conhecida e informe Z/T corretos. Comece com filtro desativado, crop `0` e offset `0`. Confira cada plano selecionado antes de experimentar recorte, filtro de bordas e deslocamentos. Este procedimento é uma proposta de validação, não uma instrução para considerar o arquivo atual pronto.

## Validação sugerida

- Use Z=3 e T=2 com o plano de maior foco conhecido em cada tempo.
- Compare a seleção com uma referência calculada independentemente; inclua o caso em que o máximo ocorre após uma queda intermediária da pontuação.
- Teste imagens uniformes e totalmente pretas, offsets nos limites, recorte maior que a altura e entrada com número incorreto de imagens.
- Compare os pixels copiados com o plano original: filtro e recorte devem afetar apenas a escolha, se essa for a finalidade adotada.
- Confira C/Z/T, intervalo temporal e calibração espacial do TIFF reaberto.

## Autoria e referência registradas

Mario Cruz; Cimini’s Lab, Broad Institute of MIT and Harvard. Última atualização declarada: 18/07/2022.

O cabeçalho pede citação em publicações e menciona: Sun et al. (2004), *Microscopy Research and Technique* 65, 139–149, algoritmo F-11 “Normalized Variance”; e Richard Mort, 27/09/2018. A referência completa e a relação precisa entre essas contribuições não foram verificadas nesta revisão.
