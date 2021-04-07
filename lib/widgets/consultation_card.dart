import 'package:flutter/material.dart';
import 'package:ylc/models/data_models/consultation_model.dart';
import 'package:ylc/models/enums/consultation_type.dart';
import 'package:ylc/user_config.dart';
import 'package:ylc/utils/helpers.dart';
import 'package:ylc/values/colors.dart';
import 'package:ylc/widgets/hide_widget.dart';
import 'package:ylc/widgets/profile_image.dart';

class ConsultationCard extends StatelessWidget {
  final ConsultationModel model;
  final VoidCallback onTap;

  const ConsultationCard({Key key, this.model, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String userId = AppConfig.userId;
    final details = model.getDetailsToShow(userId);
    final isOver = DateTime.now().millisecondsSinceEpoch >= model.endTime;
    final textColor = isOver ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: isOver ? Colors.red : YlcColors.categoryBackGround,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            HideWidget(
              hide: model.isAdvocate(userId)
                  ? model.acceptedByAdvocate
                  : model.acceptedByUser,
              child: Text(
                'Action Required,Tap for more info',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: ProfileImage.lightColor(
                photo: details.photo,
              ),
              trailing: Icon(
                icon(model.type),
                size: 24,
                color: textColor,
              ),
              title: Text(
                details.name,
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(
                      model.startTime,
                    ).date,
                    style: TextStyle(fontSize: 12, color: textColor),
                  ),
                  SizedBox(height: 4),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(
                          model.startTime,
                        ).time +
                        ' - ' +
                        DateTime.fromMillisecondsSinceEpoch(
                          model.endTime,
                        ).time,
                    style: TextStyle(fontSize: 12, color: textColor),
                  ),
                ],
              ),
              onTap: () => onTap(),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  IconData icon(ConsultationType type) {
    print(type);
    switch (type) {
      case ConsultationType.Video:
        return Icons.video_call;
        break;
      case ConsultationType.Call:
        return Icons.phone;
        break;
      case ConsultationType.Chat:
        return Icons.chat;
        break;
    }
    return Icons.warning;
  }
}
