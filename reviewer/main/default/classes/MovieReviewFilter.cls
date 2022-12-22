/**
 * Find movie reviews that contain keywords defined in the Movie_Review_Keyword__mdt
 */
public with sharing class MovieReviewFilter implements ReviewValidator {
  public List<Movie_Review__c> reviewsToFilter = new List<Movie_Review__c>();

  public MovieReviewFilter() {
  }

  /**
   * @return list of custom metadata type: Movie_Review_Keyword__mdt record sObjects
   */
  private List<Movie_Review_Keyword__mdt> getKeywordCustomMetadata() {
    List<Movie_Review_Keyword__mdt> movieReviewKeywords = Movie_Review_Keyword__mdt.getAll().values();
    return movieReviewKeywords;
  }

  /**
   * @return list of defined keyword labels
   */
  private List<String> getKeywordLabels(List<Movie_Review_Keyword__mdt> keywordMetadata) {
    List<String> keywordLabels = new List<String>();
    for (Movie_Review_Keyword__mdt mdt : keywordMetadata) {
      keywordLabels.add(mdt.Label);
    }
    return keywordLabels;
  }

  /**
   * Method executes SOSL query to check for Movie Reviews existing in database containg specified keywords
   * @return list of Movie Reviews existing in database marked for moderation for containing specified keywords
   */
  public List<Movie_Review__c> filterExistingReviews() {
    List<String> keywordLabels = getKeywordLabels(getKeywordCustomMetadata());
    String keywordsJoined = String.join(keywordLabels, ' OR ');

    String query = 'FIND {' + keywordsJoined + '} RETURNING Movie_Review__c (Id, Review__c) LIMIT 2000';
    List<List<SObject>> badReviews = Search.query(query);

    List<Movie_Review__c> reviewsToMark = (List<Movie_Review__c>) badReviews[0];

    return reviewsToMark;
  }

  /**
   * Recieves a list of non commited Movie Reviews and filters the ones containing specified keywords
   */
  public List<Movie_Review__c> filterReviews(List<Movie_Review__c> movieReviewList) {
    Matcher matcher;
    List<Movie_Review__c> reviewsToMark = new List<Movie_Review__c>();
    List<String> keywordLabels = getKeywordLabels(getKeywordCustomMetadata());
    Pattern pattern = Pattern.compile('(?i)' + String.join(keywordLabels, '|'));

    for (Movie_Review__c review : movieReviewList) {
      matcher = pattern.matcher(review.Review__c);
      if (matcher.find()) {
        reviewsToMark.add(review);
      }
    }
    return reviewsToMark;
  }
}
