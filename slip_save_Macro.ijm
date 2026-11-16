// ======================================================
// STACK TO IMAGES + SALVAR COM LABEL ORIGINAL + _mask.tif
// ======================================================

// Diretório de saída
outputDir = getDirectory("Choose output directory");

// Número de slices
n = nSlices;

// Separar stack
run("Stack to Images");

// Loop pelas imagens abertas
for (i = n; i >= 1; i--) {

    // Seleciona a última imagem aberta
    selectImage(nImages());

    // Nome atual da imagem (label original)
    label = getTitle();

    // Remove extensão se existir
    label = replace(label, ".tif", "");
    label = replace(label, ".tiff", "");

    // Garantir que não duplique _mask
    if (!endsWith(label, "_mask"))
        filename = label + "_mask.tif";
    else
        filename = label + ".tif";

    // Salvar
    saveAs("Tiff", outputDir + filename);

    close();
}

print("Finalizado preservando labels.");