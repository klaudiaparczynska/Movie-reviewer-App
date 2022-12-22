public with sharing class InvocableValidatorService {
    @InvocableMethod
    public static void hideReviews() {
        MovieReviewFilter filter = new MovieReviewFilter();
        List<Movie_Review__c> reviews = filter.filterExistingReviews();
        MovieReviewService.hideReview(reviews);
    }

}
