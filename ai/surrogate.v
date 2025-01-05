module ai

import math
import math.stats

// Model Surrogate menggunakan Gaussian Process
struct Surrogate {
mut:
    x_train [][]f64  // parameter training [learning_rate, epochs]
    y_train []f64    // hasil loss
    length_scale f64 = 0.1
}

// Kernel function dengan variance sampling
fn (s Surrogate) kernel(x1 []f64, x2 []f64) f64 {
    mut diff := []f64{len: x1.len}
    for i in 0..x1.len {
        diff[i] = x1[i] - x2[i]
    }
    variance := stats.sample_variance(diff)
    return math.exp(-0.5 * variance / (s.length_scale * s.length_scale))
}

// Prediksi dengan sample variance
fn (s Surrogate) predict(x []f64) (f64, f64) {
    if s.x_train.len == 0 {
        return 0.0, 1.0
    }
    
    k_star := s.x_train.map(s.kernel(x, it))
    
    mut weighted_sum := 0.0
    for i in 0..k_star.len {
        weighted_sum += k_star[i] * s.y_train[i]
    }
    mean := stats.mean([weighted_sum])
    variance := stats.sample_variance(k_star)
    
    return mean, variance
}
