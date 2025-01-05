module ai 

const reset = '\x1b[0m'
const yellow = '\x1b[33m'
const red = '\x1b[31m'
const bold = '\x1b[1m'
const italic = '\x1b[3m'
const title = bold + yellow 

// Turunan fungsi aktivasi sigmoid
fn sigmoid_derivative(x f64) f64 {
    return x * (1.0 - x)
}
