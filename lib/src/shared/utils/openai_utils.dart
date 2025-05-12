import 'package:dart_openai/dart_openai.dart';
import 'package:recapnote/src/shared/constants/strings.dart';

class OpenAIUtils {
  static List<OpenAIChatCompletionChoiceMessageModel> generateRequestMessages(
    String question,
  ) {
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      role: OpenAIChatMessageRole.assistant,
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          Strings.systemMessage,
        ),
      ],
    );

    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(question),

        // ! image url contents are allowed only for models with image support such gpt-4.
        // OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(
        //   "https://placehold.co/600x400",
        // ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    return [systemMessage, userMessage];
  }
}
