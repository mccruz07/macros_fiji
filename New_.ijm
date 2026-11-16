inputDir  = getDirectory("Pasta de entrada");
outputDir = getDirectory("Pasta de saída");
fs = File.separator;

run("Bio-Formats Macro Extensions");
setBatchMode(true);

allFiles = getFileList(inputDir);

for (i = 0; i < allFiles.length; i++) {
    if (!endsWith(allFiles[i], ".lif")) continue;

    fileName = allFiles[i];
    filePath = inputDir + fileName;

    baseName = File.getNameWithoutExtension(fileName);

    // Obter o número de séries no arquivo LIF
    Ext.setId(filePath);
    Ext.getSeriesCount(seriesCount);
    nSeries = seriesCount;

    for (s = 0; s < nSeries; s++) {

        // Abrir a série s como um hyperstack
        run("Bio-Formats Importer",
            "open=[" + filePath + "] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT series_" + s);

        // Sanear o nome da série
        Ext.getSeriesName(seriesName);
        bad = "\\/:*?\"<>|";
        for (c = 0; c < lengthOf(bad); c++)
            seriesName = replace(seriesName, substring(bad, c, c+1), "_");

        // Dividir os canais
        run("Split Channels");

        // Achar as imagens dos canais C1 e C2
        idList = getList("image.titles");

        ch1ID = -1;
        ch2ID = -1;

        // Encontrar o ID das imagens para C1 e C2
        for (j = 0; j < idList.length; j++) {
            title = idList[j];
            if (startsWith(title, "C1-")) {
                ch1ID = getImageID(); // Seleciona e pega o ID
                selectImage(ch1ID); // Seleciona a imagem CH1
            }
            if (startsWith(title, "C2-")) {
                ch2ID = getImageID(); // Seleciona e pega o ID
                selectImage(ch2ID); // Seleciona a imagem CH2
            }
        }

        // --- Processar CH1 (C1) ---
        selectImage(ch1ID);
        nz = nSlices();  // Número de planos Z
        if (nz > 1) {
            run("Z Project...", "projection=[Max Intensity]");
        } else {
            rename("MAX_C1");  // Se não tiver Z, mantém o nome da imagem como MAX_C1
        }
        proj1ID = getImageID();
        close(ch1ID);

        // --- Processar CH2 (C2) ---
        selectImage(ch2ID);
        nz = nSlices();  // Número de planos Z
        if (nz > 1) {
            run("Z Project...", "projection=[Max Intensity]");
        } else {
            rename("MAX_C2");  // Se não tiver Z, mantém o nome da imagem como MAX_C2
        }
        proj2ID = getImageID();
        close(ch2ID);

        // --- Merge dos dois canais projetados ---
        run("Merge Channels...", "c1=[" + getTitle(proj1ID) + "] c2=[" + getTitle(proj2ID) + "] create");
        merged = getImageID();

        // Salvar o arquivo final
        saveName = baseName + "_series" + s + "_" + seriesName + "_MERGE.tif";
        saveAs("Tiff", outputDir + fs + saveName);

        // Fechar todas as janelas abertas antes de processar a próxima série
        run("Close All");
    }
}

print("Finalizado!");
