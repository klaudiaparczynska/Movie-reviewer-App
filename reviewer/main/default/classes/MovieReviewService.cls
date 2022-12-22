public with sharing class MovieReviewService {
  public static void hideReview(List<Movie_Review__c> reviews) {
    for (Movie_Review__c review : reviews) {
      review.Visibility__c = false;
    }
    update reviews;
  }
}
