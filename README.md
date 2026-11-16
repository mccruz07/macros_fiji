# Macros para Fiji / ImageJ

Acervo de macros e trechos de automação para Fiji / ImageJ. O objetivo é guardar as rotinas e explicar o que fazem, para facilitar consultas e adaptações futuras. Há conversores, processamento de séries e auxiliares para stacks de máscaras.

Os arquivos têm diferentes estágios de desenvolvimento e incluem rotinas dependentes de nomes de janelas ou caminhos de uma sessão específica. Manter uma macro no acervo não significa que ela esteja pronta para qualquer conjunto de imagens. Variantes e rascunhos são preservados quando ajudam a entender usos anteriores.

## Catálogo

### Macros da primeira coleção

| Macro | Comportamento atual / finalidade | Documentação |
| --- | --- | --- |
| [`czitotiff.ijm`](czitotiff.ijm) | Importa séries de arquivos CZI e tenta salvá-las como TIFF, usando o nome da cena | [Guia](docs/czitotiff.md) |
| [`svstotiff.ijm`](svstotiff.ijm) | Importa uma série selecionada de arquivos SVS, converte em RGB e salva TIFF | [Guia](docs/svstotiff.md) |
| [`saveallopenimages.ijm`](saveallopenimages.ijm) | Salva as imagens abertas como TIFF e fecha todas | [Guia](docs/saveallopenimages.md) |
| [`splittime.ijm`](splittime.ijm) | Importa arquivos `.tif` como hyperstacks | [Guia](docs/splittime.md) |
| [`FindFocusMacroEdge.ijm`](FindFocusMacroEdge.ijm) | Pretende selecionar um plano focal por tempo usando uma medida de variância | [Guia](docs/FindFocusMacroEdge.md) |

### Conversão LIF e auxiliares de máscaras

| Macro | O que faz / pretende fazer | Antes de reutilizar | Documentação |
| --- | --- | --- | --- |
| [LifToTif.ijm](LifToTif.ijm) | Exportar séries LIF separadas por canal | Conferir índices de série, nomes e seleção das janelas | [Guia](docs/LifToTif.md) |
| [LifToTiff_zproject_merge.ijm](LifToTiff_zproject_merge.ijm) | Converter LIF com projeção máxima, merge e canais individuais opcionais | Conferir seleção das séries, canais e títulos usados no merge | [Guia](docs/LifToTiff_zproject_merge.md) |
| [New_.ijm](New_.ijm) | Rascunho de projeção e merge de C1/C2 em LIF | Revisar obtenção dos IDs e fechamento das imagens | [Guia](docs/New_.md) |
| [name_macro.ijm](name_macro.ijm) | Copiar labels de um stack para outro e acrescentar _mask | Ajustar títulos e garantir a correspondência dos slices | [Guia](docs/name_macro.md) |
| [save_macro.ijm](save_macro.ijm) | Separar stack e salvar imagens em destino fixo | Ajustar título, caminho Windows e separador da pasta | [Guia](docs/save_macro.md) |
| [slip_save_Macro.ijm](slip_save_Macro.ijm) | Separar stack ativo e salvar TIFFs com sufixo _mask | Conferir labels/títulos, extensões e imagens abertas | [Guia](docs/slip_save_Macro.md) |

### Como escolher entre as variantes

- **LIF por canal:** `LifToTif` registra o fluxo simples. `LifToTiff_zproject_merge` acrescenta opções de projeção e merge. `New_` fica como rascunho específico de dois canais, com problemas descritos no guia.
- **Stacks de máscaras:** `name_macro` ajusta labels e não salva; `save_macro` exporta usando título/caminho fixos; `slip_save_Macro` exporta o stack ativo para uma pasta escolhida e acrescenta `_mask`.
- **Todas as imagens já abertas:** `saveallopenimages` salva as janelas existentes sem executar Stack to Images.

Essas macros não precisam ser executadas em sequência. No caso dos labels, uma sequência possível é preparar o stack de destino com `name_macro`, conferir os labels e então exportá-lo com `slip_save_Macro`. Nenhuma delas cria máscaras por segmentação.

## Requisitos

- Fiji / ImageJ com suporte a macros `.ijm`.
- Bio-Formats, incluindo **Bio-Formats Importer** e **Bio-Formats Macro Extensions**, para `czitotiff`, `svstotiff`, `splittime` e os três conversores LIF (`LifToTif`, `LifToTiff_zproject_merge` e `New_`).
- Memória suficiente para carregar as imagens. As macros não implementam um fluxo de processamento por blocos; SVS grandes e séries extensas podem exigir muita memória.

## Como executar

1. Baixe os arquivos do repositório e mantenha a estrutura de pastas.
2. Leia a documentação da macro desejada, principalmente a seção de limitações.
3. Abra o arquivo `.ijm` no editor do Fiji, por exemplo por **File > Open…**.
4. Execute pelo comando **Run** do editor e preencha as janelas apresentadas.
5. Inspecione os resultados: dimensões, canais, planos Z, tempos, tipo de pixel e calibração, conforme a tarefa.

Os códigos não oferecem uma política explícita para nomes repetidos. `saveallopenimages` fecha todas as imagens ao terminar; a macro de foco também fecha outras imagens durante o processamento.

## Organização

```text
macros_fiji/
├── README.md
├── *.ijm                 # macros, com os nomes originais
└── docs/
    ├── <nome da macro>.md # um guia para cada macro
    └── ACERVO.md          # registro das inclusões e contexto de uso
```

Os nomes originais das macros foram preservados. Cada guia inclui objetivo, entradas, opções, saídas, modo de uso e limitações observadas.

## Autoria e referências

A macro de foco pede citação quando usada para gerar dados de publicações e menciona o algoritmo F-11, “Normalized Variance”, de Sun et al. (2004), *Microscopy Research and Technique*, 65, 139–149, além de Richard Mort (27/09/2018). 

Ao registrar uso científico, informe a macro, o autor indicado, o repositório e a versão ou commit efetivamente utilizado. Não há DOI ou versão de lançamento informados no material recebido.


