#include <stdio.h>
#include <stdlib.h>
#include <fftw3.h>
#include <complex.h>
#include <math.h>
#include <sys/time.h>

double __log_finite(double x) { return log(x); }

int main() {
    int i, j, t;
    FILE *ifp, *ofp;
    int frameId = 0;
    char file_name[100];

    char buffer_f[17];
    char filter[17][17];
    static int template[144][144];
    static float template_f[128][128];
    int fi, fj;
    int val;

    unsigned char buffer[512];
    static unsigned char img[512][512];
    static unsigned char roiimg[144][144];
    static float roiimg_f[128][128];
    int roi_row_start = 192;
    int roi_col_start = 192;

    fftw_complex *in, *out;
    fftw_plan p;

    in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * 128);
    out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * 128);

    static float complex fftimg[128][128];
    static float complex ffttml[128][128];
    static float complex crosscorr[128][128];
    static int crosscorrabs[128][128];

    float maxcorr = 0;
    float curcorr = 0;
    int max_j = 0, max_i = 0;

    int avr_mot_i = 0;
    int avr_mot_j = 0;
    int slow_drift_i = 0;
    int slow_drift_j = 0;
    int cnt_frame = 0;

    float max_tml_r = 0;
    float min_tml_r = 10000;
    float max_tml_i = 0;
    float min_tml_i = 10000;
    float max_img_r = 0;
    float min_img_r = 10000;
    float max_img_i = 0;
    float min_img_i = 10000;

    // Read in contrast filter coefficients
    sprintf(file_name, "./filter8bit.bin");
    if (!(ifp = fopen(file_name, "rb"))) {
        printf("File filter8bit.bin cannot be opened for read.\n");
        return -1;
    }
    for (j = 0; j < 17; ++j) {
        fread(buffer_f, 1, 17, ifp);
        for (i = 0; i < 17; ++i) {
            filter[j][i] = buffer_f[i];
        }
    }
    fclose(ifp);

    // Read in template
    if (!(ifp = fopen("../getMeanAsTml/template.txt", "r"))) {
        printf("File template.txt cannot be opened for read.\n");
        return -1;
    }
    for (j = 0; j < 144; ++j) {
        for (i = 0; i < 144; ++i) {
            fscanf(ifp, "%d", &val);
            template[j][i] = val;
        }
    }

    for (j = 0; j < 128; ++j) {
        for (i = 0; i < 128; ++i) {
            val = 0;
            for (fj = 0; fj < 17; ++fj) {
                for (fi = 0; fi < 17; ++fi) {
                    val += (template[j+fj][i+fi] * filter[fj][fi]);
                }
            }
            template_f[j][i] = (float) val;
        }
    }

    //for (i = 0; i < 128; ++i) {
    //    printf("%f\n", template_f[0][i]);
    //}
    //return 0;

    // Horizontal 1D FFT for template
    for (j = 0; j < 128; ++j) {
        for (i = 0; i < 128; ++i) {
            in[i][0] = template_f[j][i];
            in[i][1] = 0;
        }
        p = fftw_plan_dft_1d(128, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
        fftw_execute(p);
        for (i = 0; i < 128; ++i) {
            ffttml[j][i] = out[i][0] + out[i][1] * I;
        }
    }

    // Vertical 1D FFT for template
    for (j = 0; j < 128; ++j) {
        for (i = 0; i < 128; ++i) {
            in[i][0] = creal(ffttml[i][j]);
            in[i][1] = cimag(ffttml[i][j]);
        }
        p = fftw_plan_dft_1d(128, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
        fftw_execute(p);
        for (i = 0; i < 128; ++i) {
            ffttml[i][j] = out[i][0] + out[i][1] * I;
        }
    }

    // Open mot_vector.txt for motion vector write back.
    if (!(ofp = fopen("mot_vector.txt","w"))) {
        printf("File mot_vector.txt cannot be opened for write.\n");
        return -1;
    }

    for (frameId = 0; frameId < 1000; ++frameId) {
        // Read in image
        sprintf(file_name, "../image/image_f%03d.bin", frameId);
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

        for (j = 0; j < 144; ++j) {
            for (i = 0; i < 144; ++i) {
                roiimg[j][i] = img[j+roi_row_start-8-1-slow_drift_j][i+roi_col_start-8-1-slow_drift_i];
            }
        }

        // Preprocessing: 17x17 Gaussian filtering
        for (j = 0; j < 128; ++j) {
            for (i = 0; i < 128; ++i) {
                val = 0;
                for (fj = 0; fj < 17; ++fj) {
                    for (fi = 0; fi < 17; ++fi) {
                        val += (roiimg[j+fj][i+fi] * filter[fj][fi]);
                    }
                }
                roiimg_f[j][i] = (float) val;
            }
        }

        // Horizontal 1D FFT for image
        for (j = 0; j < 128; ++j) {
            for (i = 0; i < 128; ++i) {
                in[i][0] = roiimg_f[j][i];
                in[i][1] = 0;
            }
            p = fftw_plan_dft_1d(128, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
            fftw_execute(p);
            for (i = 0; i < 128; ++i) {
                fftimg[j][i] = out[i][0] + out[i][1] * I;
            }
        }

        // Vertical 1D FFT for image
        for (j = 0; j < 128; ++j) {
            for (i = 0; i < 128; ++i) {
                in[i][0] = creal(fftimg[i][j]);
                in[i][1] = cimag(fftimg[i][j]);
            }
            p = fftw_plan_dft_1d(128, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
            fftw_execute(p);
            for (i = 0; i < 128; ++i) {
                fftimg[i][j] = out[i][0] + out[i][1] * I;
            }
        }

        for (j = 0; j < 128; ++j) {
            for (i = 0; i < 128; ++i) {
                if (creal(ffttml[j][i]) > max_tml_r)
                    max_tml_r = creal(ffttml[j][i]);
                if (creal(ffttml[j][i]) < min_tml_r)
                    min_tml_r = creal(ffttml[j][i]);
                if (cimag(ffttml[j][i]) > max_tml_i)
                    max_tml_i = cimag(ffttml[j][i]);
                if (cimag(ffttml[j][i]) < min_tml_i)
                    min_tml_i = cimag(ffttml[j][i]);
                if (creal(fftimg[j][i]) > max_img_r)
                    max_img_r = creal(fftimg[j][i]);
                if (creal(fftimg[j][i]) < min_img_r)
                    min_img_r = creal(fftimg[j][i]);
                if (cimag(fftimg[j][i]) > max_img_i)
                    max_img_i = cimag(fftimg[j][i]);
                if (cimag(fftimg[j][i]) < min_img_i)
                    min_img_i = cimag(fftimg[j][i]);
            }
        }

        float creal_v = 0;
        float cimag_v = 0;
        for (j = 0; j < 128; ++j) {
            for (i = 0; i < 128; ++i) {
                fftimg[j][i] = (ffttml[j][i] / 8192) * conj((fftimg[j][i] / 8192));
                /*
                creal_v = (int)creal(ffttml[j][i]/8192) * (int)creal(fftimg[j][i]/8192) + 
                    (int)cimag(ffttml[j][i]/8192) * (int)cimag(fftimg[j][i]/8192);
                cimag_v = -(int)creal(ffttml[j][i]/8192) * (int)cimag(fftimg[j][i]/8192) +
                    (int)cimag(ffttml[j][i]/8192) * (int)creal(fftimg[j][i]/8192);
                fftimg[j][i] = creal_v + cimag_v * I;
                */
            }
        }

        // Horizontal 1D IFFT
        for (j = 0; j < 128; ++j) {
            for (i = 0; i < 128; ++i) {
                in[i][0] = creal(fftimg[j][i]);
                in[i][1] = cimag(fftimg[j][i]);
            }
            p = fftw_plan_dft_1d(128, in, out, FFTW_BACKWARD, FFTW_ESTIMATE);
            fftw_execute(p);
            for (i = 0; i < 128; ++i) {
                crosscorr[j][i] = (out[i][0] + out[i][1] * I);
            }
        }

        // Vertical 1D IFFT
        for (j = 0; j < 128; ++j) {
            for (i = 0; i < 128; ++i) {
                in[i][0] = creal(crosscorr[i][j]);
                in[i][1] = cimag(crosscorr[i][j]);
            }
            p = fftw_plan_dft_1d(128, in, out, FFTW_BACKWARD, FFTW_ESTIMATE);
            fftw_execute(p);
            for (i = 0; i < 128; ++i) {
                crosscorr[i][j] = out[i][0] + out[i][1] * I;
            }
        }

        for (j = 0; j < 128; ++j) {
            for (i = 0; i < 128; ++i) {
                crosscorrabs[j][i] = (int)((fabs(creal(crosscorr[j][i]))/2+fabs(cimag(crosscorr[j][i]))/2));
            }
        }

        /*
        for (j = 125; j < 128; ++j) {
            for (i = 125; i < 128; ++i) {
                printf("%d, ", crosscorrabs[j][i]);
            }
            printf("\n");
        }
        return 0;
        */

        maxcorr = 0;
        curcorr = 0;
        max_j = 0;
        max_i = 0;
        for (j = 0; j < 128; ++j) {
            for (i = 0; i < 128; ++i) {
                curcorr = crosscorrabs[j][i];
                if (curcorr > maxcorr) {
                    maxcorr = curcorr;
                    max_j = j;
                    max_i = i;
                }
            }
        }

        if (max_j > 64)
            max_j = max_j - 128;
        if (max_i > 64)
            max_i = max_i - 128;

        max_j = max_j + slow_drift_j;
        max_i = max_i + slow_drift_i;

        printf("mot_j = %d, mot_i = %d\n", max_j, max_i);
        fprintf(ofp, "%d %d\n", max_i, max_j);

        if (cnt_frame == 0) {
            cnt_frame++;
            avr_mot_i = max_i;
            avr_mot_j = max_j;
        }
        else if (cnt_frame == 199) {
            cnt_frame = 0;
            avr_mot_i += max_i;
            avr_mot_j += max_j;
            slow_drift_i = (avr_mot_i / 200);
            slow_drift_j = (avr_mot_j / 200);
            //printf("avr_mot_i = %d, avr_mot_j = %d\n", avr_mot_i, avr_mot_j);
            //printf("slow_drift_i = %d, slow_drift_j = %d\n", slow_drift_i, slow_drift_j);
        }
        else {
            cnt_frame++;
            avr_mot_i += max_i;
            avr_mot_j += max_j;
        }
    }

    /*
    printf("max_tml_r = %f, min_tml_r = %f\n", (max_tml_r/8192), (min_tml_r/8192));
    printf("max_tml_i = %f, min_tml_i = %f\n", (max_tml_i/8192), (min_tml_i/8192));
    printf("max_img_r = %f, min_img_r = %f\n", (max_img_r/8192), (min_img_r/8192));
    printf("max_img_i = %f, min_img_i = %f\n", (max_img_i/8192), (min_img_i/8192));
    */

    fclose(ofp);

    printf("Processing complete.\n");
    return 0;
}







