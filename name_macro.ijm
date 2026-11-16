orig = "TEM_mito.tif";
dest = "mito_maks_final.tif";

selectWindow(orig);
n = nSlices;

for (i = 1; i <= n; i++) {

	setSlice(i);
	label = getInfo("slice.label");
	
	selectWindow(dest);
	setSlice(i);
	
	// remove extensões se existirem
	label = replace(label, ".tiff", "");
	label = replace(label, ".tif", "");
	
	setMetadata("Label", label + "_mask");
	
	selectWindow(orig);


}
