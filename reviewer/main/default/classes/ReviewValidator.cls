public interface ReviewValidator {
  List<Movie_Review__c> filterExistingReviews();
  List<Movie_Review__c> filterReviews(List<Movie_Review__c> reviews);
}
