#include <stdio.h>
#include <stdlib.h>

int main() {

    FILE *ifp, *ofp;
    int i, j, t;
    static unsigned char img[1000][972][1296];
    unsigned char buffer[1296];
    char file_name[100];

    if (!(ifp = fopen("./image.bin","rb"))) {
        printf("File image.bin cannot be opened for read.\n");
        return -1;
    }

    for (t = 0; t < 1000; ++t) {
        for (j = 0; j < 972; ++j) {
            fread(buffer, 1, 1296, ifp);
            for (i = 0; i < 1296; ++i) {
                img[t][j][i] = buffer[i];
            }
        }
    }

    for (t = 0; t < 1000; ++t) {
        sprintf(file_name, "../image/image_f%03d.bin", t);
        if (!(ofp = fopen(file_name, "wb"))) {
            printf("File %s cannot be opened for write.\n", file_name);
        }
        for (j = 0; j < 972; ++j) {
            for (i = 0; i < 1296; ++i) {
                buffer[i] = img[t][j][i];
            }
            fwrite(buffer, 1, 1296, ofp);
        }
        fclose(ofp);
    }

    fclose(ifp);

    printf("Processing complete.\n");
    return 0;
}


