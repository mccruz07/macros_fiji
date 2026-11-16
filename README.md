# Macros para Fiji / ImageJ

Coleção de macros para conversão de imagens de microscopia, salvamento de imagens abertas e processamento de séries temporais.

> Esta documentação descreve o código fornecido, sem modificá-lo. Algumas contêm problemas conhecidos; consulte o estado de cada uma antes de usar.

## Catálogo

| Macro | Comportamento atual / finalidade | Estado da revisão | Documentação |
| --- | --- | --- | --- |
| [`czitotiff.ijm`](czitotiff.ijm) | Importa séries de arquivos CZI e tenta salvá-las como TIFF, usando o nome da cena | Requer correção do filtro de arquivos e validação dos nomes de saída | [Guia](docs/czitotiff.md) |
| [`svstotiff.ijm`](svstotiff.ijm) | Importa uma série selecionada de arquivos SVS, converte em RGB e salva TIFF | Repete a mesma série; requer correção do filtro e do laço | [Guia](docs/svstotiff.md) |
| [`saveallopenimages.ijm`](saveallopenimages.ijm) | Salva as imagens abertas como TIFF e fecha todas | Revisada estaticamente; execução não testada | [Guia](docs/saveallopenimages.md) |
| [`splittime.ijm`](splittime.ijm) | Importa arquivos `.tif` como hyperstacks | Incompleta: não separa tempos e não salva arquivos | [Guia](docs/splittime.md) |
| [`FindFocusMacroEdge.ijm`](FindFocusMacroEdge.ijm) | Pretende selecionar um plano focal por tempo usando uma medida de variância | Requer correções de sintaxe e lógica; não usar como rotina validada | [Guia](docs/FindFocusMacroEdge.md) |

## Requisitos

- Fiji / ImageJ com suporte a macros `.ijm`.
- Bio-Formats, incluindo **Bio-Formats Importer** e **Bio-Formats Macro Extensions**, para `czitotiff`, `svstotiff` e `splittime`.
- Memória suficiente para carregar as imagens. As macros não implementam um fluxo de processamento por blocos; SVS grandes e séries extensas podem exigir muita memória.

Não há versão mínima ou combinação de Fiji, ImageJ, Bio-Formats e sistema operacional validada nesta revisão.

## Como executar

1. Baixe os arquivos do repositório e mantenha a estrutura de pastas.
2. Leia a documentação da macro desejada, principalmente a seção de limitações.
3. Abra o arquivo `.ijm` no editor do Fiji, por exemplo por **File > Open…**.
4. Execute pelo comando **Run** do editor e preencha as janelas apresentadas.
5. Inspecione os resultados: dimensões, canais, planos Z, tempos, tipo de pixel e calibração, conforme a tarefa.

Para os primeiros testes, use cópias pequenas das imagens e uma pasta de saída vazia. Os códigos não oferecem uma política explícita para nomes repetidos. `saveallopenimages` fecha todas as imagens ao terminar; a macro de foco também fecha outras imagens durante o processamento.

## Organização

```text
macros_fiji/
├── README.md
├── czitotiff.ijm
├── svstotiff.ijm
├── saveallopenimages.ijm
├── splittime.ijm
├── FindFocusMacroEdge.ijm
└── docs/
    ├── czitotiff.md
    ├── svstotiff.md
    ├── saveallopenimages.md
    ├── splittime.md
    ├── FindFocusMacroEdge.md
    └── VALIDACAO.md
```

Os nomes originais das macros foram preservados. Cada guia inclui objetivo, entradas, opções, saídas, modo de uso e limitações observadas.

## Validação e desenvolvimento

Consulte [problemas conhecidos e roteiro de validação](docs/VALIDACAO.md). A documentação distingue a finalidade pretendida do comportamento implementado. Os roteiros de teste são propostas para execução futura, não resultados de testes realizados.

## Autoria e referências

Os cabeçalhos de `czitotiff.ijm`, `svstotiff.ijm` e `FindFocusMacroEdge.ijm` atribuem a autoria a **Mario Cruz** e mencionam o **Cimini’s Lab, Broad Institute of MIT and Harvard**. As datas registradas são 29/07/2022 para os conversores CZI/SVS e 18/07/2022 para a macro de foco. Os outros dois arquivos não contêm identificação de autoria no código fornecido.

A macro de foco pede citação quando usada para gerar dados de publicações e menciona o algoritmo F-11, “Normalized Variance”, de Sun et al. (2004), *Microscopy Research and Technique*, 65, 139–149, além de Richard Mort (27/09/2018). Essas informações foram transcritas do cabeçalho; a referência bibliográfica completa ainda precisa ser conferida.

Ao registrar uso científico, informe a macro, o autor indicado, o repositório e a versão ou commit efetivamente utilizado. Não há DOI ou versão de lançamento informados no material recebido.

