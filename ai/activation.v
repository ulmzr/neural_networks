module ai

import math

// Fungsi aktivasi yang tersedia
pub enum ActivationType {
    sigmoid
    relu
    tanh
}

// Fungsi aktivasi Sigmoid: range [0,1]
pub fn sigmoid(x f64) f64 {
    return 1.0 / (1.0 + math.exp(-x))
}

// Fungsi aktivasi ReLU: max(0,x)
pub fn relu(x f64) f64 {
    return if x > 0 { x } else { 0 }
}

// Fungsi aktivasi Tanh: range [-1,1]
pub fn tanh(x f64) f64 {
    return math.tanh(x)
}

// Aplikasikan fungsi aktivasi sesuai tipe
pub fn activate(x f64, activation_type ActivationType) f64 {
    return match activation_type {
        .sigmoid { sigmoid(x) }
        .relu { relu(x) }
        .tanh { tanh(x) }
    }
}
