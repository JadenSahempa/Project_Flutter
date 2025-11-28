import 'package:flutter_test/flutter_test.dart';
import 'package:luar_sekolah_lms/week_7/data/models/course_model.dart';
import 'package:luar_sekolah_lms/week_7/domain/entities/course_entity.dart';

void main() {
  test('Coursemodel.fromJson harus parsing JSON dengan benar', () {
    final json = {
      'id': '1',
      'name': 'Flutter Basic',
      'price': '0.00',
      'categoryTag': ['flutter', 'mobile'],
      'thumbnail': null,
      'rating': null,
      'createdBy': 'admin',
      'createdAt': '2025-01-01T00:00:00.000Z',
      'updatedAt': '2025-01-02T00:00:00.000Z',
    };

    final model = CourseModel.fromJson(json);

    // cek field satu per satu
    expect(model.id, '1');
    expect(model.name, 'Flutter Basic');
    expect(model.price, '0.00');
    expect(model.categoryTag, contains('flutter'));
    expect(model.createdBy, 'admin');

    // optional: pastikan dia juga valid sebagai CourseEntity
    expect(model, isA<CourseEntity>());
  });
}
