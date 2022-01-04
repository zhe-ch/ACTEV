#include <stdio.h>
#include <stdlib.h>

#define SUB_N 128
#define ROI_ROW_START 88
#define ROI_COL_START 146

int mean(int n, int x[]) {
    int temp;
    int i;

    temp = 0;
    for (i = 0; i < n; ++i) {
        temp += x[i];
    }

    return (temp/n);
}

int main() {
    int i, j, t;
    FILE *ifp, *ofp;
    int frameId = 0;
    char file_name[100];

    unsigned char buffer[420];
    static unsigned char img[315][420];
    static unsigned char imgS[30][144][144];
    int val;
    int element[30];
    static int template[144][144];

    char temp_str[9];

    for (t = 0; t < 990; t += 33) {
        sprintf(file_name, "../image/image_f%03d.bin", t);
        if (!(ifp = fopen(file_name, "rb"))) {
            printf("File image_f%03d.bin cannot be opened for read.\n", 0);
            return -1;
        }
        for (j = 0; j < 315; ++j) {
            fread(buffer, 1, 420, ifp);
            for (i = 0; i < 420; ++i) {
                img[j][i] = buffer[i];
            }
        }
        for (j = 0; j < 144; ++j) {
            for (i = 0; i < 144; ++i) {
                imgS[t/33][j][i] = img[j+ROI_ROW_START-8-1][i+ROI_COL_START-8-1];
            }
        }
        fclose(ifp);
    }

    // Compute template
    for (j = 0; j < 144; ++j) {
        for (i = 0; i < 144; ++i) {
            for (t = 0; t < 30; ++t) {
                element[t] = imgS[t][j][i];
            }
            template[j][i] = mean(30, element);
        }
    }

    // Check correctness of the template.
    /*
    for (j = 0; j < 5; ++j) {
        for (i = 0; i < 5; ++i) {
            printf("%d,", template[j][i]);
        }
        printf("\n");
    }
    return 0;
    */

    // Open img_mem.coe file for write.
    if (!(ofp = fopen("tml_mem.coe", "w"))) {
        printf("File tml_mem.coe cannot be opened for write.\n");
        return -1;
    }

    fprintf(ofp, "memory_initialization_radix=16;\n");
    fprintf(ofp, "memory_initialization_vector=\n");

    for (j = 0; j < 144; ++j) {
        for (i = 0; i < 144; i += 4) {
            sprintf(temp_str, "%02x%02x%02x%02x", template[j][i+3], template[j][i+2],
                    template[j][i+1], template[j][i+0]);
            fprintf(ofp, "%s\n", temp_str);
        }
    }

    fclose(ofp);

    // Open template.txt for template store
    if (!(ofp = fopen("template.txt","w"))) {
        printf("File template.txt cannot be opened for write.\n");
        return -1;
    }
    for (j = 0; j < 144; ++j) {
        for (i = 0; i < 144; ++i) {
           fprintf(ofp, "%d\n", template[j][i]);
        }
    }
    fclose(ofp);

    printf("Processing complete.\n");
    return 0;
}

