public with sharing class HelperClassToHideReview {
  public static List<Movie_Review__c> makeData(Id recordId) {
    List<Movie_Review__c> reviews = new List<Movie_Review__c>();
    Movie_Review__c movRev = [
      SELECT Id, Review__c, Visibility__c
      FROM Movie_Review__c
      WHERE Id = :recordId AND Visibility__c = TRUE
    ];
    reviews.add(movRev);
    return reviews;
  }
  @AuraEnabled(cacheable=true)
  public static List<Movie_Review__c> getRecordWithVisibleReview(Id recordId) {
    List<Movie_Review__c> results = makeData(recordId);
    return results;
  }
  @AuraEnabled
  public static List<Movie_Review__c> hideReview(Id recordId) {
    List<Movie_Review__c> results = makeData(recordId);
    MovieReviewService.hideReview(results);
    return results;
  }
}
