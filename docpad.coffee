# API Keys
TUMBLR_API_KEY = process.env.TUMBLR_API_KEY or 'zjl94wRf2vIoa1XrIjpacBRnwbsISgX0OPVsGG4T9hRvwhJaPj'
SOUNDCLOUD_CLIENT_ID = process.env.SOUNDCLOUD_CLIENT_ID or 'ea5f91809133eacd8d92c9291b770a61'

# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
module.exports = {
	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ
	templateData:

		# Moment
		moment: require('moment')

		# Specify the theme we are using
		theme: "metro"

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://your-website.com"

			# The default title of our website
			title: "Your Website"

			# The website author's name
			author: "Your Name"

			# The website author's email
			email: "b@lupton.cc"

			# The website heading to be displayed on the page
			heading: 'Your Website'

			# The website subheading to be displayed on the page
			subheading: """
				Welcome to your new <t>links.docpad</t> website!
				"""

			# Footer
			footnote: """
				This website was created with <t>links.bevry</t>’s <t>links.docpad</t>
				"""
			copyright: """
				Your chosen license should go here... Not sure what a license is? Refer to the <code>README.md</code> file included in this website.
				"""

			# The website description (for SEO)
			description: """
				When your website appears in search results in say Google, the text here will be shown underneath your website's title.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				place, your, website, keywoards, here, keep, them, related, to, the, content, of, your, website
				"""

			# The website analytics codes for various servers
			analytics:
				# ReInvigorate is a real-time analytics service
				reinvigorate: false # instead of false, use your reinvigorate tracker id here

				# Google Analytics is the most popular analytics service
				google: false  # instead of false, use your google analytics tracker id here


			# Specify some feed available for the visitors of our website
			feeds: [
					# This is the feed generated by our DocPad website
					# It contains all the posts, you can find the source file in src/documents/atom.xml.eco
					href: 'http://your-website.com/atom.xml'
					name: 'Blog Posts'
				,
					# DocPad's Twitter Stream
					# Included here as an example that you can include feed from anywhere
					href: 'https://api.twitter.com/1/statuses/user_timeline.atom?screen_name=docpad&count=20&include_entities=true&include_rts=true'
					name: 'DocPad Tweets'
			]


			# Do you have social accounts?
			# Mention them here and our layout will include them in the sidebar
			# If you specify a feed for the Feedr plugin (specified later on)
			# then we will pull in their feed data too for recognised services
			social:
				# DocPad's Twitter Profile
				# Included here as an example
				twitter:
					name: 'Twitter'
					url: 'https://twitter.com/docpad'
					profile:
						feeds:
							tweets: 'twitter'

				# Balupton's GitHub Profile
				# Included here as an example
				github:
					name: 'GitHub'
					url: 'https://github.com/balupton'
					profile:
						feeds:
							user: 'githubUser'
							repos: 'githubRepos'

				# Balupton's Vimeo Profile
				# Included here as an example
				vimeo:
					name: 'Vimeo'
					url: 'https://vimeo.com/balupton'

				# Balupton's Flickr Profile
				# Included here as an example
				flickr:
					name: 'Flickr'
					url: 'http://www.flickr.com/people/balupton/'

				# Balupton's Soundcloud Profile
				soundcloud:
					name: 'Soundcloud'
					url: 'http://soundcloud.com/balupton'
					profile:
						feeds:
							user: 'soundcloudUser'
							tracks: 'soundcloudTracks'

		# -----------------------------
		# Common links used throughout the website

		links:
			docpad: '<a href="https://github.com/bevry/docpad" title="Visit on GitHub">DocPad</a>'
			historyjs: '<a href="https://github.com/balupton/history.js" title="Visit on GitHub">History.js</a>'
			bevry: '<a href="http://bevry.me" title="Visit Website">Bevry</a>'
			opensource: '<a href="http://en.wikipedia.org/wiki/Open-source_software" title="Visit on Wikipedia">Open-Source</a>'
			html5: '<a href="http://en.wikipedia.org/wiki/HTML5" title="Visit on Wikipedia">HTML5</a>'
			javascript: '<a href="http://en.wikipedia.org/wiki/JavaScript" title="Visit on Wikipedia">JavaScript</a>'
			nodejs: '<a href="http://nodejs.org/" title="Visit Website">Node.js</a>'
			author: '<a href="http://balupton.com" title="Visit Website">Benjamin Lupton</a>'
			cclicense: '<a href="http://creativecommons.org/licenses/by/3.0/" title="Visit Website">Creative Commons Attribution License</a>'
			mitlicense: '<a href="http://creativecommons.org/licenses/MIT/" title="Visit Website">MIT License</a>'
			contact: '<a href="mailto:b@bevry.me" title="Email me">Email</a>'


		# -----------------------------
		# Helper Functions

		# Get Gravatar URL
		getGravatarUrl: (email,size) ->
			hash = require('crypto').createHash('md5').update(email).digest('hex')
			url = "http://www.gravatar.com/avatar/#{hash}.jpg"
			if size then url += "?s=#{size}"
			return url

		# Get Profile Feeds
		getSocialFeeds: (socialID) ->
			feeds = {}
			for feedID,feedKey of @site.social[socialID].profile.feeds
				feeds[feedID] = @feedr.feeds[feedKey]
			return feeds

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')


	# =================================
	# Collections
	# These are special collections that our website makes available to us

	collections:
		# For instance, this one will fetch in all documents that have pageOrder set within their meta data
		pages: (database) ->
			database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])

		# This one, will fetch in all documents that have the tag "post" specified in their meta data
		posts: (database) ->
			database.findAllLive({relativeOutDirPath:'posts'},[date:-1])


	# =================================
	# Plugin Configuration
	# This is where we configure the different plugins that are loaded with DocPad
	# To configure a plugin, specify it's name, and then the options you want to configure it with

	plugins:

		# Configure the Feedr Plugin
		# The Feedr Plugin will pull in remote feeds specified here and make their contents available to our templates
		feedr:
			
			# These are the feeds that Feedr will pull in
			feeds:
				# Twitter
				# Included here as an example
				twitter: url: "https://api.twitter.com/1/statuses/user_timeline.json?screen_name=balupton&count=50&include_entities=false&include_rts=false&exclude_replies=true"

				# Github
				# Included here as an example
				githubUser: url: "https://api.github.com/users/balupton"
				githubRepos: url: "https://api.github.com/users/balupton/repos?sort=updated"

				# Vimeo
				# Included here as an example
				vimeo: url: "http://vimeo.com/api/v2/balupton/videos.json"

				# Flickr
				# Included here as an example
				flickr: url: "http://api.flickr.com/services/feeds/photos_public.gne?id=35776898@N00&lang=en-us&format=json"

				# Tumblr
				tumblr: url: "http://api.tumblr.com/v2/blog/balupton.tumblr.com/posts?api_key=#{TUMBLR_API_KEY}"

				# Soundcloud
				soundcloudUser: url: "https://api.soundcloud.com/users/balupton.json?client_id=#{SOUNDCLOUD_CLIENT_ID}"
				soundcloudTracks: url: "https://api.soundcloud.com/users/balupton/tracks.json?client_id=#{SOUNDCLOUD_CLIENT_ID}"
}