import 'package:flutter_test/flutter_test.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/ratings.dart';
import 'package:myplug_ca/core/domain/models/rating.dart';

void main() {
  group('Config functions', () {
    test('Test get Conversation Id', () {
      //ARRANGE
      const senderId = 'hello';
      const receiverId = 'world';

      //ACT
      final conversationId =
          createConversationId(senderId: senderId, receiverId: receiverId);

      //ASSERT
      expect(conversationId, 'hello_world');
    });

    test('Test format price', () {
      //ARRANGE
      const amount = 4000.0;

      //ACT
      final price = formatPrice(amount: amount);

      //ASSERT
      expect(price, '₦4,000.00');
    });

    test('Test format data', () {
      //ARRANGE
      final givenDate = DateTime.now();

      //ACT
      final expectedDate = formatDate(date: givenDate);

      //ASSERT
      expect(expectedDate, 'Tue, 5 Aug 25');
    });

    group('Test average rating', () {
      test('more than one value in list', () {
//ARRANGE
        List<Rating> listOfRatings = demoRatings;

//ACT
        final average = getAverageRating(ratings: listOfRatings);

//ASSERT
        expect(average, 3.5);
      });
      test('only one value in list', () {
//ARRANGE
        List<Rating> listOfRatings = demoRatings.sublist(0, 1);

//ACT
        final average = getAverageRating(ratings: listOfRatings);

//ASSERT
        expect(average, 4.0);
      });

      test('empty list', () {
//ARRANGE
        List<Rating> listOfRatings = [];

//ACT
        final average = getAverageRating(ratings: listOfRatings);

//ASSERT
        expect(average, 0.0);
      });
    });
  });
}
