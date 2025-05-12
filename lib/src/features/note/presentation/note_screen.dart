import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recapnote/src/features/note/presentation/controllers/create_note_controller.dart';
import 'package:recapnote/src/features/note/presentation/providers/note_data_state_provider.dart';
import 'package:recapnote/src/shared/constants/app_colors.dart';
import 'package:recapnote/src/shared/utils/openai_utils.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class NoteScreen extends ConsumerStatefulWidget {
  const NoteScreen({super.key});

  @override
  ConsumerState<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends ConsumerState<NoteScreen>
    with SingleTickerProviderStateMixin {
  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController _controller = TextEditingController();
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;
  bool _speechEnabled = false;
  bool hasCanceled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();

    _colorController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _colorAnimation = _colorController.drive(
      TweenSequence<Color?>([
        TweenSequenceItem(
          tween: ColorTween(
            begin: Colors.blue.withValues(alpha: 0.2),
            end: Colors.purple.withValues(alpha: 0.2),
          ),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(
            begin: Colors.purple.withValues(alpha: 0.2),
            end: Colors.green.withValues(alpha: 0.2),
          ),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(
            begin: Colors.green.withValues(alpha: 0.2),
            end: Colors.orange.withValues(alpha: 0.2),
          ),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(
            begin: Colors.orange.withValues(alpha: 0.2),
            end: Colors.blue.withValues(alpha: 0.2),
          ),
          weight: 1,
        ),
      ]),
    );
    // Initial state
    _colorController.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    _colorController.dispose();
    super.dispose();
  }

  // HANDLERS
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (err) => debugPrint('Speech error: $err'),
      onStatus: (status) {
        debugPrint('Speech status: $status');
        setState(() {});
      },
    );
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _stopListening() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult && !hasCanceled) {
      setState(() {
        final current = _controller.text.trimRight();
        final recognized = result.recognizedWords.trim();

        _controller.text =
            current.isEmpty ? recognized : '$current $recognized';

        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      });
    }
  }

  void _handleSpeech() {
    if (_speechToText.isNotListening) {
      _startListening();
      _colorController.repeat();
    }
  }

  void _handleSpeechCancel() {
    if (_speechToText.isListening) {
      setState(() => hasCanceled = true);
      _stopListening();
      _colorController.stop();
    }
  }

  void _handleSpeechApply() {
    if (_speechToText.isListening) {
      _stopListening();
      _colorController.stop();
      setState(() => hasCanceled = false);
    }
  }

  void _handleSubmit() async {
    final question = _controller.text;
    debugPrint('Submitted question: $question');

    final requestMessages = OpenAIUtils.generateRequestMessages(question);

    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat
        .create(
          model: "gpt-4o",
          seed: 6,
          messages: requestMessages,
          temperature: 0.2,
          // maxTokens: 2000,
        );

    final message = chatCompletion.choices.first.message;
    final contentItems = message.content;

    if (contentItems != null && contentItems.isNotEmpty) {
      final contentItem = contentItems.first;
      final raw = contentItem.text!.trim();
      final lines = raw.split('\n');

      final headlingLine = lines.firstWhere(
        (line) => line.trimLeft().startsWith('##'),
        orElse: () => '',
      );

      final title =
          headlingLine.isNotEmpty
              ? headlingLine.replaceFirst('##', '').trim()
              : 'Unknown';

      ref.read(noteDataStateProvider.notifier).setQuestion(question);
      ref.read(noteDataStateProvider.notifier).setAnswer(raw);
      ref.read(noteDataStateProvider.notifier).setTitle(title);

      ref.read(createNoteControllerProvider.notifier).createNote();
    }

    _controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(createNoteControllerProvider);

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    enabled: !_speechToText.isListening,
                    maxLines: 12,
                    minLines: 12,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: AppColors.appBlack),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: AppColors.appGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: AppColors.appBlue),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Speech Button
                        Material(
                          color: Colors.transparent,
                          shape: CircleBorder(
                            side: BorderSide(
                              width: 1,
                              color: AppColors.appGray,
                            ),
                          ),
                          child: InkWell(
                            customBorder: CircleBorder(),
                            onTap: _handleSpeech,
                            child: AnimatedBuilder(
                              animation: _colorAnimation,
                              builder: (context, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        _speechToText.isListening
                                            ? _colorAnimation.value
                                            : Colors.transparent,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.mic_none_rounded,
                                      color: AppColors.appBlack,
                                      size: 24,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        if (_speechToText.isListening) ...[
                          // Speech Cancel Button
                          Material(
                            color: Colors.transparent,
                            shape: CircleBorder(
                              side: BorderSide(
                                width: 1,
                                color: AppColors.appGray,
                              ),
                            ),
                            child: InkWell(
                              customBorder: CircleBorder(),
                              onTap: _handleSpeechCancel,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: AppColors.appBlack,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Speech Apply Button
                          Material(
                            color: Colors.transparent,
                            shape: CircleBorder(
                              side: BorderSide(
                                width: 1,
                                color: AppColors.appGray,
                              ),
                            ),
                            child: InkWell(
                              customBorder: CircleBorder(),
                              onTap: _handleSpeechApply,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.check_rounded,
                                  color: AppColors.appBlack,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          // Submit Button
                          Material(
                            color: Colors.transparent,
                            shape: CircleBorder(
                              side: BorderSide(
                                width: 1,
                                color: AppColors.appGray,
                              ),
                            ),
                            child: InkWell(
                              customBorder: CircleBorder(),
                              onTap: _handleSubmit,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.send_rounded,
                                  color: AppColors.appBlack,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
