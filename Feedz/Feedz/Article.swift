//
//  Article.swift
//  Feedz
//
//  Created by Morgan Collino on 11/21/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

import Foundation

class Article : NSObject
{
	let article_id : Int!
	let author : Int!
	public let title : String!
	let content : NSData!
	let images : Array!
	let littleImage : String!
	let bigImage : String!
	let lDescription: String!
	let seeder_id: Int! // Provider of the article eg: Buzzfeed, CNet, ...
	
	init (article_id: Int, author: Int, title: String, content: NSData, images: NSArray?, littleImage:String?, bigImage:String?, lDescription: String?, seeder_id: Int) {
		self.article_id = article_id
		self.author = author
		self.title = title
		self.content = content
		self.images	= images;
		self.littleImage = littleImage
		self.bigImage = bigImage
		self.lDescription = lDescription
		self.seeder_id = seeder_id
	}

}