#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define N_FRAME 1000
#define CELL_NUM 1024
#define LOAD_NUM 1024

int main() {
    int i, j;
    int c;
    FILE *ifp, *ofp;
    int frameId = 0;
    char file_name[100];

    unsigned char buffer[512];
    static unsigned char img[512][512];
    static unsigned char img_ext[514][514];
    static unsigned char img_f[512][512];
    static unsigned char img_ero[512][512];
    static unsigned char img_open[512][512];
    static unsigned char img_enhance[512][512];
    static unsigned char img_enh_mc[512][512];

    char* subString;

    static int cell_center[CELL_NUM][2] = {0};
    static int cell_contour[CELL_NUM][25][25] = {0};
    static int trace[CELL_NUM][N_FRAME];
    static int fil_trace[CELL_NUM][N_FRAME];

    int max_trace[CELL_NUM] = {0};
    int min_trace[CELL_NUM] = {0};

    int mot_vector_x[N_FRAME] = {0};
    int mot_vector_y[N_FRAME] = {0};

    unsigned char acc0, acc1, acc2;

    unsigned char val;
    int fi, fj;

    sprintf(file_name, "mot_vector.txt");
    if (!(ifp = fopen(file_name, "r"))) {
        printf("File mot_vector.txt cannot be opened for read.\n");
        return -1;
    }
    for (i = 0; i < N_FRAME; ++i) {
        fscanf(ifp, "%d %d", &mot_vector_x[i], &mot_vector_y[i]);
    }
    fclose(ifp); 

    sprintf(file_name, "tile_contours.txt");
    if (!(ifp = fopen(file_name, "r"))) {
        printf("File tile_contours.txt cannot be opened for read.\n");
        return -1;
    }

    fgets(buffer, 512, ifp);
    for (c = 0; c < CELL_NUM; ++c) {
        fgets(buffer, 512, ifp);   // Get cell ID
        fgets(buffer, 512, ifp);   // Get cell center
        subString = strtok(buffer, "<, >");
        cell_center[c][0] = atoi(subString);
        subString = strtok(NULL, "<, >");
        cell_center[c][1] = atoi(subString);
        for (j = 0; j < 25; ++j) {
            fgets(buffer, 512, ifp);
            subString = strtok(buffer, "{,}");
            cell_contour[c][j][0] = atoi(subString);
            for (i = 1; i < 25; ++i) {
                subString = strtok(NULL, "{,}");
                cell_contour[c][j][i] = atoi(subString);
            }
        }
    }

    for (c = 0; c < CELL_NUM; ++c) {
        max_trace[c] = 0;
        min_trace[c] = 255 * 25 * 25;
    }

    for (frameId = 0; frameId < N_FRAME; ++frameId) {
        // Read in image
        sprintf(file_name, "../image/image_f%05d.bin", frameId);
        if (!(ifp = fopen(file_name, "rb"))) {
            printf("File image.bin cannot be opened for read.\n");
            return -1;
        }
        for (j = 0; j < 512; ++j) {
            fread(buffer, 1, 512, ifp);
            for (i = 0; i < 512; ++i) {
                img[j][i] = buffer[i];
            }
        }
        fclose(ifp);

        for (j = 0; j < 512; ++j) {
            for (i = 0 ; i < 512; ++i) {
                img_ext[j+1][i+1] = img[j][i];
            }
        }

        // Denoise 3x3 filter
        for (j = 0; j < 512; ++j) {
            for (i = 0; i < 512; ++i) {
                acc0 = (img_ext[j][i] + img_ext[j+1][i]) >> 1;
                acc0 = (acc0 + img_ext[j+2][i]) >> 1;
                acc1 = (img_ext[j][i+1] + img_ext[j+1][i+1]) >> 1;
                acc1 = (acc1 + img_ext[j+2][i+1]) >> 1;
                acc2 = (img_ext[j][i+2] + img_ext[j+1][i+2]) >> 1;
                acc2 = (acc2 + img_ext[j+2][i+2]) >> 1;
                img_f[j][i] = (acc1 + acc2) >> 1;
                img_f[j][i] = (img_f[j][i] + acc0) >> 1;
            }
        }

        // Grayscale opening (erosion + dilation, 19x19 kernel size)
        for (j = 0; j < 512; ++j) {
            for (i = 0; i < 512; ++i) {
                val = 255;
                for (fj = -9; fj <= 9; ++fj) {
                    for (fi = -9; fi <= 9; ++fi) {
                        if (((j+fj)>=0)&&((j+fj)<512)&&((i+fi)>=0)&&((i+fi)<512)) {
                            if (img_f[j+fj][i+fi] < val) {
                                val = img_f[j+fj][i+fi];
                            }
                        }
                    }
                }
                img_ero[j][i] = val;
            }
        }

        for (j = 0; j < 512; ++j) {
            for (i = 0; i < 512; ++i) {
                val = 0;
                for (fj = -9; fj <= 9; ++fj) {
                    for (fi = -9; fi <= 9; ++fi) {
                        if (((j+fj)>=0)&&((j+fj)<512)&&((i+fi)>=0)&&((i+fi)<512)) {
                            if (img_ero[j+fj][i+fi] > val) {
                                val = img_ero[j+fj][i+fi];
                            }
                        }
                    }
                }
                img_open[j][i] = val;
            }
        }

        for (j = 0; j < 512; ++j) {
            for (i = 0; i < 512; ++i) {
                img_enhance[j][i] = img_f[j][i] - img_open[j][i];
            }
        }

        for (j = 0; j < 512; ++j) {
            for (i = 0; i < 512; ++i) {
                if (((j-mot_vector_y[frameId])>=0)&&((j-mot_vector_y[frameId])<512)&&
                    ((i-mot_vector_x[frameId])>=0)&&((i-mot_vector_x[frameId])<512)) {

                    img_enh_mc[j][i] = img_enhance[j-mot_vector_y[frameId]][i-mot_vector_x[frameId]];
                }
                else {
                    img_enh_mc[j][i] = 0;
                }
            }
        }

        for (c = 0; c < CELL_NUM; ++c) {
            trace[c][frameId] = 0;
            for (j = 0; j < 25; ++j) {
                for (i = 0; i < 25; ++i) {
                    if ((cell_center[c][0]+j-12>=0) && (cell_center[c][0]+j-12<512) &&
                            (cell_center[c][1]+i-12>=0) && (cell_center[c][1]+i-12<512)) {
                        trace[c][frameId] += (cell_contour[c][j][i] * img_enh_mc[cell_center[c][0]+j-12][cell_center[c][1]+i-12]);
                    }
                }
            }

            // Drop filter
            /*
            if (frameId == 0) {
                fil_trace[c][frameId] = trace[c][frameId];
            }
            else {

                if (trace[c][frameId] < 0.95 * trace[c][frameId-1]) {
                    fil_trace[c][frameId] = 0.95 * trace[c][frameId-1];
                }
                else {
                    fil_trace[c][frameId] = trace[c][frameId];
                }
            }
            */

            fil_trace[c][frameId] = trace[c][frameId];

            if (fil_trace[c][frameId] > max_trace[c])
                max_trace[c] = fil_trace[c][frameId];
            if (fil_trace[c][frameId] < min_trace[c])
                min_trace[c] = fil_trace[c][frameId];
        }

        printf("[Info] Frame %d is analyzed.\n", (frameId + 1));
    }

    // Save traces into TXT files.
    for (c = 0; c < CELL_NUM; ++c) {
        sprintf(file_name, "./traces/trace%04d.txt", (c+1));
        if (!(ofp = fopen(file_name, "w"))) {
            printf("File trace%04d.txt cannot be opened for write.\n", (c+1));
            return -1;
        }
        for (frameId = 0; frameId < N_FRAME; ++frameId) {
            fprintf(ofp, "%d\n", fil_trace[c][frameId]);
        }
        fclose(ofp);
    }

    // Save max/min ranges into TXT file.
    sprintf(file_name, "./max_min_range.txt");
    if (!(ofp = fopen(file_name, "w"))) {
        printf("File max_min_range.txt cannot be opened for write.\n");
        return -1;
    }
    for (c = 0; c < CELL_NUM; ++c) {
        fprintf(ofp, "%d, %d\n", min_trace[c], max_trace[c]);
    }
    fclose(ofp);

    printf("Processing complete.\n");
    return 0;
}

