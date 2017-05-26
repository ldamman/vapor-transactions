import XCTest
import Testing
import HTTP
import Sockets
import MySQLProvider
@testable import Vapor
@testable import App

class TransactionTests: TestCase {
	func testThrowDuringTransaction() throws {
		let drop = try Droplet.testable()
		let sampleContent = "transactionTestContent"

		try Post.makeQuery().filter("content", sampleContent).delete()

		XCTAssertNil(try Post.makeQuery().filter("content", sampleContent).first())

		try? drop.mysql().transaction { connection in
			let newPost = Post(content: sampleContent)
			try newPost.save()
			throw Abort.badRequest
		}

		XCTAssertNil(try Post.makeQuery().filter("content", sampleContent).first())
	}
}
