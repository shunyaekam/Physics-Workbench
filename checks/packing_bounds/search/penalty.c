/* Sum squared excesses over either all pairs or a fixed list of near pairs. */
#include <string.h>

static double pair(int dim, double threshold, const double *a, const double *b,
                   double *grad_a, double *grad_b) {
    double dot = 0.0;
    for (int k = 0; k < dim; k++) dot += a[k] * b[k];
    double excess = dot - threshold;
    if (excess <= 0.0) return 0.0;
    for (int k = 0; k < dim; k++) {
        grad_a[k] += excess * b[k];
        grad_b[k] += excess * a[k];
    }
    return 0.5 * excess * excess;
}

double penalty(int n, int dim, double threshold, double *x, double *grad,
               int edge_count, int *edges) {
    double total = 0.0;
    memset(grad, 0, sizeof(double) * n * dim);
    if (edge_count < 0) {
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < i; j++) {
                total += pair(dim, threshold, x + i*dim, x + j*dim,
                              grad + i*dim, grad + j*dim);
            }
        }
    } else {
        for (int k = 0; k < edge_count; k++) {
            int i = edges[2*k], j = edges[2*k+1];
            total += pair(dim, threshold, x + i*dim, x + j*dim,
                          grad + i*dim, grad + j*dim);
        }
    }
    return total;
}
