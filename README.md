## New York Times
NYTimes is an iOS mobile app written using swift 5. It follows the MVVM architectural pattern. It is fully independant, i.e. does not rely on any external dependency. This application's purpose is to display the "Most Popular" articles, search them, and display each one's details.

## Testing
Tests are split into two separate classes; a class that tests the `ArticleRepository`, and another that tests the `HomeViewModel`. To achieve the tests related to the `ArticleRepository`, some classes were created to make use of the json file embedded and to mock the response. The tests were done as follows:

*	`ArticleRepositoryTests`:
	*	`testArticlesOK` makes sure that the response is properly handled and that the decoding is passing.
	*	`testArticlesNoResponseError` makes sure that an error is returned when there is no response returned from the server.
	*	`testArticles404Error` makes sure that an error is also returned when the server returns a status code not in the 200 -> 299 range.
*	`HomeViewModelTests`:
	*	`testFetchDataOK` is called to make sure that the data is being returned to the ViewModel.
	*	`testSearchNoResultsOK`, `testSearchResetOK`, `testSearchByTitleOK`, `testSearchByLineOK`, `testSearchCaseInsensitiveOK` are used to check that the search functionality is working.

## Installation
Download the application from github repository and open it using Xcode.
