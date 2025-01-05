module main

import rand
import os

//const labels           = ['Apel', 'Jeruk', 'Mangga', 'Pisang', 'Jengkol', 'Durian']
//const labels           = ['A', 'B', 'C', 'D', 'E', 'F']
const labels           = ['0.1', '0.2', '0.3', '0.4', '0.5', '0.6']
//mut file_content       = '# Weight (g), Vitamin C (mg/100g), Roughness (1-100), Name\n'
const name             = 'sample'
const count            = 50

fn random_data(name string) string {
	mut weight    := 0.0
	mut vitamin_c := 0.0
	mut roughness := 0.0

	match name {
        // Apel
		labels[0] {
			weight = rand.f64_in_range(70.0, 250.0) or { 0.0 }
			vitamin_c = rand.f64_in_range(4.0, 5.0) or { 0.0 }
			roughness = rand.f64_in_range(5.0, 15.0) or { 0.0 }
		}
        // Jeruk
		labels[1] {
			weight = rand.f64_in_range(100.0, 300.0) or { 0.0 }
			vitamin_c = rand.f64_in_range(45.0, 70.0) or { 0.0 }
			roughness = rand.f64_in_range(15.0, 25.0) or { 0.0 }
		}
        // Mangga
		labels[2] {
			weight = rand.f64_in_range(200.0, 600.0) or { 0.0 }
			vitamin_c = rand.f64_in_range(27.0, 35.0) or { 0.0 }
			roughness = rand.f64_in_range(10.0, 20.0) or { 0.0 }
		}
        // Pisang
		labels[3] {
			weight = rand.f64_in_range(80.0, 200.0) or { 0.0 }
			vitamin_c = rand.f64_in_range(8.0, 12.0) or { 0.0 }
			roughness = rand.f64_in_range(3.0, 10.0) or { 0.0 }
		}
        // Jengkol
		labels[4] {
			weight = rand.f64_in_range(15.0, 30.0) or { 0.0 }
			vitamin_c = rand.f64_in_range(23.0, 25.0) or { 0.0 }
			roughness = rand.f64_in_range(30.0, 45.0) or { 0.0 }
		}
        // Durian
		labels[5] {
			weight = rand.f64_in_range(1000.0, 4000.0) or { 0.0 }
			vitamin_c = rand.f64_in_range(19.0, 25.0) or { 0.0 }
			roughness = rand.f64_in_range(85.0, 100.0) or { 0.0 }
		}
		else {}
	}

    return '${weight:.2f}, ${vitamin_c:.2f}, ${roughness:.2f}, $name\n'
}

fn main() {
	mut file_content    := ''
	// Generate 100 random fruits
	for _ in 0..count {
		data_label := labels[rand.intn(labels.len) or { 0 }]
        file_content += '${random_data(data_label)}'
	}
    filename := '${name}.csv'
	os.write_file(filename, file_content) or { panic(err) }
	println('Data has been generated and saved to ${filename}')
}
