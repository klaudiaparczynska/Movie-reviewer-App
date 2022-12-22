public with sharing class InvocableValidator {
  public class FlowInput {
    @InvocableVariable
    public Movie_Review__c movieReviewInput;
  }

  @InvocableMethod
  public static FlowOutput[] filterReviews(List<FlowInput> params) {
    FlowOutput[] results = new List<FlowOutput>();
    MovieReviewFilter filter = new MovieReviewFilter();
    List<Movie_Review__c> reviews = new List<Movie_Review__c>();
    for (FlowInput input : params) {
      reviews.add(input.movieReviewInput);
    }
    List<Movie_Review__c> filteredReviews = filter.filterReviews(reviews);

    for (Movie_Review__c movieRev : filteredReviews) {
      results.add(new FlowOutput(movieRev));
    }
    return results;
  }

  public class FlowOutput {
    @InvocableVariable
    public Movie_Review__c movieReviewOutput;

    public FlowOutput(Movie_Review__c movieRev) {
      this.movieReviewOutput = movieRev;
    }
  }
}
