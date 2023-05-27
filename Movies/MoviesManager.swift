//
//  MoviesManager.swift
//  Movies
//
//  Created by Marco Alonso Rodriguez on 20/05/23.
//

import Foundation

struct MoviesManager {
    

    func getPopularMovies(completion: @escaping ([DataMovie]) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=2cfa8720256036601fb9ac4e4bce1a9b&language=es-MX&page=1") else { return }
        
        
        let tarea = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            do {
                //Decodificar la data
                let dataDecodificada = try JSONDecoder().decode(MovieDataModel.self, from: data)
                let listaPeliculas = dataDecodificada.results
                completion(listaPeliculas)
            } catch {
                print("Debug: error \(error.localizedDescription)")
                completion([])
            }
            
        }
        
        tarea.resume()
        
    }
    
    func getUpcominMovies(completion: @escaping ([DataMovie]) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=2cfa8720256036601fb9ac4e4bce1a9b&language=es-MX&page=1") else { return }
        
        
        let tarea = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            do {
                //Decodificar la data
                let dataDecodificada = try JSONDecoder().decode(MovieDataModel.self, from: data)
                let listaPeliculas = dataDecodificada.results
                completion(listaPeliculas)
            } catch {
                print("Debug: error \(error.localizedDescription)")
                completion([])
            }
            
        }
        
        tarea.resume()
        
    }
    
    func getTrailersMovie(id: Int, completion: @escaping ([Trailer]) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=2cfa8720256036601fb9ac4e4bce1a9b&language=es_MX") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _ , error in
            
            guard let data = data else { return }
            
            do {
                let respuesta = try JSONDecoder().decode(ResponseTrailerModel.self, from: data)
                let listadoTrailers = respuesta.results
                completion(listadoTrailers)
            } catch {
                print("Debug: error \(error.localizedDescription)")
            }
            
        }.resume()
        
    }
}
