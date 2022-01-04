#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CLASS_NUM 23
#define CELL_NUM 64

unsigned char * convert_to_byte(int value)
{
    static unsigned char buffer[4];

    buffer[0] = value & 0xFF;
    buffer[1] = (value >> 8) & 0xFF;
    buffer[2] = (value >> 16) & 0xFF;
    buffer[3] = (value >> 24) & 0xFF;

    return buffer;
}

int main() {
    FILE *ifp, *ofp;
    char file_name[100];
    char *subString;

    unsigned char buffer[512];
    unsigned char *byte_buffer = malloc(sizeof(unsigned char) * 4);

    int selcell_n = 0;
    int c, i;
    static int select_cell[CELL_NUM];
    static float threshold[CELL_NUM];
    static float beta[CELL_NUM][CLASS_NUM];
    static float bias[CLASS_NUM];
    int temp;

    union {
        float val;
        unsigned char bytes[4];
    } f32_data;

    // Load select cell IDs.
    sprintf(file_name, "./select_cells.txt");
    if (!(ifp = fopen(file_name, "r"))) {
        printf("File select_cells.txt cannot be opened for read.\n");
        return -1;
    }
    fgets(buffer, 512, ifp);  // Get select cell number
    subString = strtok(buffer, " ");
    subString = strtok(NULL, " ");
    selcell_n = atoi(subString);
    for (c = 0; c < selcell_n; ++c) {
        fscanf(ifp, "%d", &select_cell[c]);
    }
    fclose(ifp);

    // Load thresholds.
    sprintf(file_name, "./threshold.txt");
    if (!(ifp = fopen(file_name, "r"))) {
        printf("File threshold.txt cannot be opened for read.\n");
        return -1;
    }
    for (c = 0; c < selcell_n; ++c) {
        fscanf(ifp, "%f", &threshold[c]);
    }
    fclose(ifp);

    // Load parameters of the linear classifier.
    sprintf(file_name, "./lc_parameters.txt");
    if (!(ifp = fopen(file_name, "r"))) {
        printf("File lc_parameters.txt cannot be opened for read.\n");
        return -1;
    }
    for (c = 0; c < selcell_n; ++c) {
        for (i = 0; i < CLASS_NUM; ++i) {
            fscanf(ifp, "%f", &beta[c][i]);
        }
    }
    for (i = 0; i < CLASS_NUM; ++i) {
        fscanf(ifp, "%f", &bias[i]);
    }
    fclose(ifp);

    // Open param_mem.bin for write.
    if (!(ofp = fopen("param.bin", "wb"))) {
        printf("File param.bin cannot be opened for write.\n");
        return -1;
    }
    temp = selcell_n;
    byte_buffer = convert_to_byte(temp);
    fwrite(byte_buffer, 1, 4, ofp);
    for (c = 0; c < CELL_NUM; c = c + 4) {
        temp = select_cell[c] + (select_cell[c+1] << 8) +
            (select_cell[c+2] << 16) + (select_cell[c+3] << 24);
        byte_buffer = convert_to_byte(temp);
        fwrite(byte_buffer, 1, 4, ofp);
    }
    for (c = 0; c < CELL_NUM; ++c) {
        f32_data.val = threshold[c];
        byte_buffer = f32_data.bytes;
        fwrite(byte_buffer, 1, 4, ofp);
    }
    for (c = 0; c < CELL_NUM; ++c) {
        for (i = 0; i < CLASS_NUM; ++i) {
            f32_data.val = beta[c][i];
            byte_buffer = f32_data.bytes;
            fwrite(byte_buffer, 1, 4, ofp);
        }
    }
    for (i = 0; i < CLASS_NUM; ++i) {
        f32_data.val = bias[i];
        byte_buffer = f32_data.bytes;
        fwrite(byte_buffer, 1, 4, ofp);
    }
    fclose(ofp);

    printf("Processing complete.\n");
    return 0;
}
