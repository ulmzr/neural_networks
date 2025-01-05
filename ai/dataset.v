module ai

import os
import encoding.csv
import strconv
import arrays

@[heap]
// Struct Dataset dengan parameter normalisasi
pub struct Dataset {
pub mut:
    features       [][]f64
    labels         []f64
    normalize_type string   // Tipe normalisasi yang digunakan
    feature_min    []f64    // Nilai minimum setiap fitur
    feature_max    []f64    // Nilai maksimum setiap fitur
    feature_mean   []f64    // Nilai rata-rata setiap fitur
    feature_std    []f64    // Standar deviasi setiap fitur
    feature_median []f64    // Nilai median setiap fitur
}

struct LabelEncoder {
mut:
    label     map[string]f64
    counter   f64
}

fn new_label_encoder() LabelEncoder {
    return LabelEncoder{
        label   : map[string]f64{}
        counter : 0.0
    }
}

fn (mut encoder LabelEncoder) encode_label(label string) f64 {
    if num := strconv.parse_int(label, 0, 64) {
		return label.f64() * num/num
    }
    
    if label in encoder.label {
        return encoder.label[label]
    }
    
    encoder.label[label] = encoder.counter
    encoder.counter += 0.1
    return encoder.label[label]
}

pub fn load_dataset(filepath string) !Dataset {
    mut dataset := Dataset{
        features: [][]f64{}
        labels: []f64{}
    }

    content := os.read_file(filepath) or { 
        panic('Failed to read file: $filepath') 
    }
    
    mut reader := csv.new_reader(content)
    mut encoder := new_label_encoder()

    for {
        colums := reader.read() or { break }
        if colums.len < 2 { continue }
        
        mut features := []f64{}
        features_length := colums.len - 1

        for column in colums[..features_length] {
            value := column.trim_space().f64()
            features << value
        }
        
        label := encoder.encode_label(colums.last().trim_space())
        
        dataset.features << features
        dataset.labels << label
    }

    return dataset
}

pub fn (mut dataset Dataset) info() {
    println('${title}\nInformasi Dataset$reset')
    println('Jumlah data : ${dataset.features.len}')
    println('Jumlah fitur: ${dataset.features[0].len}')
    println('Jumlah kelas: ${arrays.distinct(dataset.labels).len}')
}

