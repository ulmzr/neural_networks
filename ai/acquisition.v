module ai
import math

// Expected Improvement (EI) acquisition function
struct Acquisition {
mut:
    best_f f64    // nilai terbaik yang ditemukan
    xi    f64 = 0.01  // exploration-exploitation trade-off
}

// Hitung Expected Improvement menggunakan fungsi error
fn (a Acquisition) compute_ei(mean f64, std f64) f64 {
    z := (mean - a.best_f - a.xi) / std
    return (mean - a.best_f - a.xi) * math.erf(z/math.sqrt2) + 
           std * math.exp(-0.5 * z * z) / math.sqrt(2.0 * math.pi)
}

// Cari parameter berikutnya yang menjanjikan
fn (mut a Acquisition) next_point(surrogate Surrogate, config BayesianConfig) []f64 {
    mut best_ei := 0.0
    mut best_params := []f64{len: 2}
    
    // Grid search sederhana
    for lr := config.min_lr; lr <= config.max_lr; lr += 0.01 {
        for epochs := config.min_epochs; epochs <= config.max_epochs; epochs += 100 {
            mut params := [lr, f64(epochs)]
            mean, std := surrogate.predict(params)
            ei := a.compute_ei(mean, std)
            
            if ei > best_ei {
                best_ei = ei
                best_params = params.clone()
            }
        }
    }
    
    return best_params
}
