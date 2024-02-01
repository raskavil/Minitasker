import Foundation

protocol Storable: Codable {
    
    var id: String { get }
    var timestamp: Date { get }
}
