import Routing
import Vapor
import Crypto

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get("hello") { req in
        return "Hello, world!"
    }
    router.get{ req -> Future<View> in
        return try req.view().render("hello")
    }
    
    let userController = UserController()
    router.post("register", use: userController.createUser)
    
    
    let middleWare = User.basicAuthMiddleware(using: BCryptDigest())
    let authedGroup = router.grouped(middleWare)
    authedGroup.post("login",use: userController.loginUser)
}

final class UserController {
    func createUser(_ request: Request) throws -> Future<User.AuthenticatedUser> {
        let futureUser = try request.content.decode(User.self)

        return futureUser.flatMap(to: User.AuthenticatedUser.self){
            user -> Future<User.AuthenticatedUser> in
            
            let hasher = try request.make(BCryptDigest.self)
            let passwordHashed = try hasher.hash(user.password)
            let newUser = User(email: user.email, password: passwordHashed)
            return newUser.save(on: request).map(to: User.AuthenticatedUser.self){
                authedUser in
                return try User.AuthenticatedUser(email: authedUser.email, id: authedUser.requireID())
            }
        }
        
    }
    func loginUser(_ request: Request) throws -> User.AuthenticatedUser {
        let user = try request.requireAuthenticated(User.self)
        return try User.AuthenticatedUser(email: user.email, id: user.requireID())
    }
}
