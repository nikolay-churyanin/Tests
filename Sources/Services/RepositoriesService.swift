//
//  RepositoriesService.swift
//  Test3
//
//  Created by Nikolay Churyanin on 22.05.2020.
//

import Alamofire

extension RepositoriesService {

    public enum LoadResult {

        case success([String])
        case failure(String)
    }
}

public enum RepositoriesService {

    private static let domainURL = "https://api.github.com/"

    public static func loadRepositories(name: String, completion: @escaping (LoadResult)->Void) {

        let method = "users/\(name)/repos"

        AF
            .request(domainURL + method)
            .responseJSON { response in
                _ = response.map { value in

                    guard let array = value as? [Any] else {
                        completion(.failure("User \"\(name)\" not fond.\n"))
                        return
                    }

                    if array.isEmpty {
                        completion(.failure("User \"\(name)\" does't have a repositories.\n"))
                        return
                    }

                    var repositories: [String] = []
                    for reposDict in array {
                        if let dict = reposDict as? [String: Any],
                            let name = dict["name"] as? String {
                            repositories.append(name)
                        }
                    }

                    completion(.success(repositories))
                }
            }
    }
}
