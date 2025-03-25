import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunicare/theme/bloc.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Using BLoC instead of Provider
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.jpg',
              height: 40,
              width: 40,
            ),
            SizedBox(width: 10),
            Text('Contact Us'),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactInfo(context),
            SizedBox(height: 30),
            _buildSocialLinks(context),
            SizedBox(height: 30),
            _buildMessageForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 16),
        _buildContactItem(
            context, Icons.email, 'Email', 'support@vaccinator.com'),
        _buildContactItem(context, Icons.phone, 'Phone', '+1 (123) 456-7890'),
        _buildContactItem(context, Icons.location_on, 'Address',
            '123 Health Street, Medical City, MC 12345'),
      ],
    );
  }

  Widget _buildContactItem(
      BuildContext context, IconData icon, String title, String content) {
    // Using BLoC instead of Provider
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Theme.of(context).primaryColorDark,
                ),
              ),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSocialLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Follow Us',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialButton(
                context, Icons.facebook, 'Facebook', 'https://facebook.com'),
            _buildSocialButton(
                context, Icons.circle, 'Twitter', 'https://twitter.com'),
            _buildSocialButton(context, Icons.camera_alt, 'Instagram',
                'https://instagram.com'),
            _buildSocialButton(
                context, Icons.video_library, 'YouTube', 'https://youtube.com'),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(
      BuildContext context, IconData icon, String name, String url) {
    // Using BLoC instead of Provider
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return InkWell(
      onTap: () => _launchUrl(url),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Theme.of(context).cardColor
                  : Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDarkMode
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColorDark,
            ),
          ),
          SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageForm(BuildContext context) {
    // Using BLoC instead of Provider
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Send Us a Message',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            labelStyle: TextStyle(
              color: isDarkMode
                  ? Colors.white70
                  : Theme.of(context).primaryColorDark,
            ),
          ),
          cursorColor: Theme.of(context).primaryColor,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            labelStyle: TextStyle(
              color: isDarkMode
                  ? Colors.white70
                  : Theme.of(context).primaryColorDark,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          cursorColor: Theme.of(context).primaryColor,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            labelText: 'Message',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            labelStyle: TextStyle(
              color: isDarkMode
                  ? Colors.white70
                  : Theme.of(context).primaryColorDark,
            ),
          ),
          maxLines: 5,
          cursorColor: Theme.of(context).primaryColor,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Message sent! We\'ll get back to you soon.'),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text('Send Message'),
            ),
            // Using the theme's button style instead of defining custom style
          ),
        ),
      ],
    );
  }
}