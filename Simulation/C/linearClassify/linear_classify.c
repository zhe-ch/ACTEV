#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CELL_NUM 89
#define LEARNER_NUM 23
#define CLASS_NUM 24

int main() {

    int c, t;
    int i;
    float v;
    FILE *ifp, *ofp;
    char* subString;
    static int spike_train[CELL_NUM][1000];
    static float beta[CELL_NUM][LEARNER_NUM];
    static float bias[LEARNER_NUM];
    static float score[LEARNER_NUM];
    int coding_matrix[CLASS_NUM][LEARNER_NUM];
    static float loss[CLASS_NUM];
    float min_loss = 0;
    static int predict_output[1000];
    static int predict_label[1000];
    char file_name[100];
    unsigned char buffer[512];
    int diff = 0;

    // Load traces.
    sprintf(file_name, "test_input.txt");
    if (!(ifp = fopen(file_name, "r"))) {
        printf("File test_input.txt cannot be opened for read.\n");
        return -1;
    }

    for (t = 0; t < 1000; ++t) {
        fgets(buffer, 512, ifp);
        subString = strtok(buffer, ",");
        spike_train[0][t] = atoi(subString);
        for (c = 1; c < CELL_NUM; ++c) {
            subString = strtok(NULL, ",");
            spike_train[c][t] = atoi(subString);
        }
    }
    fclose(ifp);

    // Load predict labels.
    sprintf(file_name, "test_labels.txt");
    if (!(ifp = fopen(file_name, "r"))) {
        printf("File test_labels.txt cannot be opened for read.\n");
        return -1;
    }
    for (t = 0; t < 1000; ++t) {
        fscanf(ifp, "%d", &predict_label[t]);
    }
    fclose(ifp);

    // Load parameters of the linear classifier.
    sprintf(file_name, "./lc_parameters.txt");
    if (!(ifp = fopen(file_name, "r"))) {
        printf("File lc_parameters.txt cannot be opened for read.\n");
        return -1;
    }
    for (c = 0; c < CELL_NUM; ++c) {
        for (i = 0; i < LEARNER_NUM; ++i) {
            fscanf(ifp, "%f", &beta[c][i]);
        }
    }
    for (i = 0; i < CLASS_NUM; ++i) {
        fscanf(ifp, "%f", &bias[i]);
    }
    fclose(ifp);

    // Build coding matrix.
    for (i = 0; i < CLASS_NUM; ++i) {
        for (c = 0; c < LEARNER_NUM; ++c) {
            if (c >= i) {
                coding_matrix[i][c] = -1;
            }
            else {
                coding_matrix[i][c] = 1;
            }
        }
    }

    // Linear classification based on computed score and loss.
    for (t = 0; t < 1000; ++t) {
        // Compute score.
        for (i = 0; i < LEARNER_NUM; ++i) {
            score[i] = bias[i];
            for (c = 0; c < CELL_NUM; ++c) {
                score[i] += (spike_train[c][t] * beta[c][i]);
            }
        }

        // Compute loss.
        for (i = 0; i < CLASS_NUM; ++i) {
            loss[i] = 0;
            for (c = 0; c < LEARNER_NUM; ++c) {
                v = 1 - score[c] * coding_matrix[i][c];
                if (v  > 0) {
                    loss[i] += v;
                }
            }
        }

        // Compute prediction result
        predict_output[t] = 0;
        min_loss = loss[0];
        for (i = 1; i < CLASS_NUM; ++i) {
            if (loss[i] < min_loss) {
                predict_output[t] = i;
                min_loss = loss[i];
            }
        }
    }

    // Save prediction results to TXT file.
    sprintf(file_name, "./prediction_result.txt");
    if (!(ofp = fopen(file_name, "w"))) {
        printf("File prediction_result.txt cannot be opened for write\n");
        return -1;
    }
    for (t = 0; t < 1000; ++t) {
        fprintf(ofp, "%d\n", predict_output[t] + 1);
    }
    fclose(ofp);

    // Check if prediction results are correct.
    for (t = 0; t < 1000; ++t) {
        diff += abs((predict_output[t] + 1) - predict_label[t]);
    }

    if (diff == 0) {
        printf("[Info] Test results are correct.\n");
    }
    else {
        printf("[Info] Result mismatch: Diff = %d\n", diff);
    }

    printf("Processing complete.\n");
    return 0;
}
